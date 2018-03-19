# sast - Simple Assembly Sequence Typing (and Profiling)


## Introduction

`sast` is a generic sequence typer for assembled genomes.  It can do MLST, but
can also be used for identification, serotyping, resistance detection, virulence
profiling, or indeed any analysis that involves locating one or more genes on a
assembled genome, and mapping the detected haplotype onto phenotypic categories.

`sast` does for assemblies what [SRST2](https://github.com/katholt/srst2)
does for short reads, with the important caveat that read-based analysis will
generally give more accurate results.  If you have reads (and time), then you
should use SRST2.

The core parameters for a `sast` run are:

* a set of genes of interest, in the form of a list of alleles for each gene
  (we call this the _query set_)
* a map from gene, allele, or allele combination to one or more categoric (type)
  variables
* a collection of genomes to be analysed (the _study set_)

The output of `sast` is a table listing for each genome in the study set:

* when *typing*: the allele detected for each of the genes, and the type (e.g.
  taxon or MLST) corresponding to this combination of alleles;
* when *profiling*: for each target category (e.g. ESBL, cytotoxin), the list
  and count of genes or alleles associated with the category

Consecutive `sast` runs against the same study set can be joined into a single
table.


## Typing vs Profiling

Brushing aside mathematical quandaries about categories and types, the
distinction is that typing assigns a genome to a single (best) type, whereas
profiling establishes a set of categories that the genome is a member of.
(IOW: typing is about what the organism _is_, profiling about what it _has_.)

For `sast` what is relevant is that the two approaches need to organise their
output differently when presented in a single table.  Parameter `--mode` can be
used to switch between "MLST", "Identification", and "Profiling" modes.

### MLST

In MLST mode (`--mode mlst`) we look for a _single tuple_ of _exact_ allele
matches for a defined _set of genes_, then map this tuple to the ST for the
genome.  If no allele is found for some gene in the profile, then ST cannot be
established.  If all genes are found but some allele does not match exactly with
a defined allele, or if all genes match exactly but the tuple does not map onto
a defined sequence type, then we have a new (unknown) ST.

In MLST mode, the minimum identity parameter defaults to 100%.  By lowering it,
you could obtain a "close ST" for a genome with one or more imperfect allele
matches.  Technically this is no proper MLST, but it ca.  _(Note to self: 'continuous ST'.)_

The query set in MLST mode must have allele headers with format `>GDN X`, where
G is the gene name (a sequence of arbitrary non-space characters), D a delimiter
(any single non-numeric character), and N is the allele identifier (numeric and
unique among all alleles for G).  X is optional text following a white space.

This convention means that you can use standard allele files (e.g. from PubMLST
or Pasteur, and including those that work with SRST2) without modification.
Note how e.g. `rpoB_1`, `>blaCTX-M-15`, and `RS31795r7` all comply and refer to
alleles 1, 15, and 7 of genes `rpoB`, `blaCTX-M`, and `RS31795` respectively.

The mapping table must be a TSV file whose first column has the ST identifier
(any string of characters), and remaining columns the allele numbers per gene.
Its header must specify the gene name corresponding to each column (matching the
"G" part in the allele headers); the first column header is used as the header
for the ST column in the `sast` output.

### Identification

In identification mode (`--mode ident`) we look for the _single allele_ that
_best_ matches any of the alleles in the query set.  The query set are alleles
(usually for a single gene, though this is not a restriction), and there
usually is only one or a few "prototypic" alleles per type (= taxon).

Matching is subject to requirements on minimum identity, and by default set to
99% (as this is a conventional setting for 16S species identity).  This mode
allows for returning multiple matches per genome (`--all`), but note that this
makes for bloated output when joining multiple `sast` runs.

The mapping table is optional.  If absent, then allele headers are reported
verbatim.  If a mapping table is specified, then its first column must have the
sequence identifier (everything between `>` and the first white space in the
allele header), and subsequent column(s) the mapped value(s).  The first column
must not have duplicate IDs.

The output consists of all columns from the matching row in the mapping table
(or just the allele header if no mapping table was used), plus identity and
allele coverage percentages.

#### Profiling

In profiling mode (`--mode profile`), the aim is to find _any match_ (subject to
identity and coverage requirements) to any gene or allele in the query set.
Every allele in the query set belongs to a group, and the set of allele 'hits'
for each group is listed in a single column in the output.

The grouping of alleles can be specified in one of two ways: by specifying a
mapping table as in identification mode (first column has sequence identifier,
second column group identifier); or by using specially formatted allele headers.
The convention for allele headers is the same as is used by SRST2

query alleles belong to 'hits' are grouped by the category of the allele.
query alleles are members of a number of groups.'hits' in the query set Contrary to 

Mapping from allele to 




## Operation

`sast` first creates a BLAST database containing the genomes.  This database
can be retained for subsequent runs, to enable quickly running a number of 
typing

It then blasts
each allele against the database, keeping for each genome, for each gene, the
best match among those that meet the percent identity and coverage constraints.  


## Installation

### Prerequisites

Apart from `blastn`, `sast` has no dependencies that a decent POSIX system
wouldn't have.

### Clone the repository

There are no installation steps.  Clone the repositoy and you're all set:

    git clone https://github.com/zwets/sast.git


## Usage

Use `sast --help`.


#### Examples

@TODO@


### License

sast - simple assembly sequence typing  
Copyright (C) 2018  Marco van Zwetselaar

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

