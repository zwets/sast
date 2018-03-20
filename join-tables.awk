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
	}

NR == 1 { # Process the RHS header line
          for (J=1; J<=NF; ++J) { RH[J]=$J; RC[$J]=J }

	  # Process the LHS header line
	  getline <LHS_FILE
	  for (I=1; I<=NF; ++I) {
		LH[I]=$I; LC[$I]=I
		if ((J = RC[$I])) { LJ[++Z] = I; RJ[Z] = J }	# Store join column Z's indices
	  }

	  # Process the rest of LHS
	  while (getline <LHS_FILE) {
		KEY = ""
		for (K=1; K<=Z; ++K) KEY = KEY SUBSEP $(LJ[K])
		if (LHS[KEY]) { print "Non-unique key. Duplicate value is " $0 >"/dev/stderr"; exit 1 } 
		LHS[KEY]=$0
	  }

	  # Print the output header
	  printf $1
	  for (I=1; I<=length(LH); ++I) printf OFS LH[I]
	  for (J=2; J<=NF; ++J) if (!(LC[RH[J]])) printf OFS $J
	  printf RS
	}

NR > 1	{ # Process RHS table coming in on stdin, taking care of stars
	  STARS = ""
	  KEY = ""
	  for (K=1; K<=Z; ++K) {
		V = $(RJ[K])
		if ((S=index(V,"*")) != 0) { 
			STARS = STARS "*"; 
			V = substr(V, 1, S-1) 
		}
		KEY = KEY SUBSEP V
	  }

	  # Look up and split the LHS entry into fields
	  L = LHS[KEY]
	  LL[1]=0; delete LL[1]	# Idiom hack to define array
	  if (L) split(L, LL)	# Else split fails

	  # Print out the RHS first column first (it is the genome ID)
	  printf $1

	  # Print out the LHS columns but use RHS values on join columns
	  for (I=1; I<=length(LH); ++I) {
		printf OFS
		RI = RC[LH[I]]
		printf RI ? $RI : L ? LL[I] STARS : "NF"
	  }

	  # Print out the RHS columns which haven't been printed yet
	  for (J=2; J<=length(RH); ++J) {
		if (!(LC[RH[J]])) printf OFS $J
	  }

	  printf RS
	}
