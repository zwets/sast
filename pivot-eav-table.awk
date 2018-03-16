#!/usr/bin/awk
#
# pivot-eav-table.awk
#
# Pivots an EAV table such that the attributes become the columns.
# Parameters
# - COUNT: output counts rather than entries (0 or 1)
# - ENT_COL: index of the column with entity identifiers (1-based)
# - ATT_COL: index of the column with attribute identifiers
# - VAL_COL: index of the column with values

BEGIN	{ FS="\t"				# Read tab-separated input
	  OFS="\t"				# Write tab-separated output 
	  ENT_COL = ENT_COL ? ENT_COL : 1	# Column containing the entity identifier
	  ATT_COL = ATT_COL ? ATT_COL : 2	# Column containing the attribute name
	  VAL_COL = VAL_COL ? VAL_COL : 3	# Column containing the entity-attribute value
	}
	{ ALL_ENTS[$ENT_COL] = $ENT_COL
	  ALL_ATTS[$ATT_COL] = $ATT_COL
	  if (COUNT) {
		ALL_DATA[$ENT_COL][$ATT_COL] += 1
	  } else {
		SEP = ALL_DATA[$ENT_COL][$ATT_COL] ? " " : ""
		ALL_DATA[$ENT_COL][$ATT_COL] = ALL_DATA[$ENT_COL][$ATT_COL] SEP $VAL_COL
	  }
        }
END	{ IGNORECASE = 1
	  N_ENTS = asort(ALL_ENTS)
	  N_ATTS = asort(ALL_ATTS)

	  printf "#Key"				# Print output header
	  for (J=1; J<=N_ATTS; ++J) printf "%s%s", FS, ALL_ATTS[J]
	  printf "%s", ORS

	  for (I=1; I<=N_ENTS; ++I) { 		# Print each record
		printf "%s", ALL_ENTS[I]
		FMT = COUNT ? "%s%d" : "%s%s"
		for (J=1; J<=N_ATTS; ++J) printf FMT, FS, ALL_DATA[ALL_ENTS[I]][ALL_ATTS[J]]
		printf "%s", ORS
	  }
	}

