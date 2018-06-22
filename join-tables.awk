#!/usr/bin/awk
#
# join-tables.awk
#
# Right join table LHS from LHS_FILE with table RHS from stdin,
# joining the two on the intersection of the LHS and RHS columns,
# checking that this intersection is a unique key for LHS,
# and outputting the union of LHS and RHS columns.
#
# Parameters
# - LHS_FILE: the LHS table is a TSV
#

BEGIN	{ FS = OFS = "\t"
	  Z = 0
	  LARR[1]=0; delete LARR[1]	# Idiom hack to define array, needed for split
	}

NR == 1 { # Process the RHS header line
          for (J=1; J<=NF; ++J) { RH[J]=$J; RC[$J]=J }

	  # Process the LHS header line
	  getline <LHS_FILE
	  for (I=1; I<=NF; ++I) {
		LH[I]=$I; LC[$I]=I
		if ((J = RC[$I])) { LJ[++Z] = I; RJ[Z] = J }	# Store join column Z's indices
	  }

	  # Print the output header - first RHS free, then LHS free, then join columns
	  printf RH[1]
	  for (J=2; J<=length(RH); ++J) if (!LC[RH[J]]) printf OFS RH[J]
	  for (I=1; I<=length(LH); ++I) if (!RC[LH[I]]) printf OFS LH[I]
	  for (J=2; J<=length(RH); ++J) if ( LC[RH[J]]) printf OFS RH[J]
	  printf RS

	  # Process the rest of LHS
	  while (getline <LHS_FILE) {
		KEY = ""
		for (K=1; K<=Z; ++K) KEY = KEY SUBSEP $(LJ[K])
		if (LHS[KEY]) { printf \
		  "Problem: duplicate entry in lookup table '" LHS_FILE "'. " \
		  "Either this is an actual duplicate, or some gene in the lookup table was not " \
		  "found in any of the sequences (and typing fails by definition). Genes found were:" >"/dev/stderr"
		  for (J=2; J<=length(RH); ++J) if (LC[RH[J]]) printf " " RH[J] >"/dev/stderr"
		  printf "\n" >"/dev/stderr"
		  exit 1
		}
		LHS[KEY]=$0
	  }
	}

NR > 1	{ # Process RHS table coming in on stdin, taking care of stars and question marks
	  STARS = ""
	  KEY = ""
	  for (K=1; K<=Z; ++K) {
		V = $(RJ[K])
		if ((S=index(V,"*")) != 0) STARS = "*" STARS
		if ((Q=index(V,"?")) != 0) STARS = STARS "?"
		if (S || Q) V = substr(V, 1, (S ? S : Q) - 1)
		KEY = KEY SUBSEP V
	  }

	  # Look up and split the LHS entry into fields
	  L = LHS[KEY]
	  if (L) split(L, LARR)

	  # Print the line - RHS free, then LHS free, then joined columns
	  printf $1
	  for (J=2; J<=length(RH); ++J) if (!LC[RH[J]]) printf OFS $J
	  for (I=1; I<=length(LH); ++I) if (!RC[LH[I]]) printf OFS (L ? LARR[I] : "NF") STARS
	  for (J=2; J<=length(RH); ++J) if ( LC[RH[J]]) printf OFS $J
	  printf RS
	}

