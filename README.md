# sast - Simple Assembly Sequence Typing


## Introduction

`sast` is a generic sequence typer for assembled genomes.  It was written to do
MLST, but could also do identification, serotyping, or indeed any analysis that
involves locating one or more genes on a assembled genome, and mapping the
detected haplotype onto phenotypic categories.

MLST looks for a tuple of exact allele matches for a defined set of genes, then
maps this tuple onto the ST for the genome.  If no exact match is found for some
gene in the profile, or if all genes match but the tuple does not map onto a
defined ST, then we have a novel (unknown) ST.

Identification is essentially the same procedure, except that usually a single
gene (across multiple taxa) is used, and there is no 100% identity requirement.
Resistance and virulence profiling are similar in operation, but differ in the
reporting: instead of a single type (= what the organism 'is'), they report
lists of properties (what the organism 'has').


## Operation

The core parameters for a `sast` run are:

* a set of genes of interest, in the form of a list of alleles for each gene
  (we call this the _query set_)
* a _mapping_ from gene, allele, or allele combination to one or more categoric
  (type) variables
* a collection of genomes to be analysed (the _study set_)

The output of `sast` is a table listing for each genome in the study set the ID
of the allele detected for each of the genes in the query set, and if a mapping
table is provided, the type (e.g.  taxon or MLST) corresponding to the
combination of alleles found.

Consecutive `sast` runs against the same study set can be joined into a single
table.  This is quick and efficient, especially when done against a large study
set, as `sast` will reuse the BLAST database that it generated the first time.

> **Caveat Emptor**
>
> `sast` operates on assemblies, not on reads.  This works fine if the assembly
> has good coverage and read depth, and (hence) is not overly fragmented.  If
> these conditions aren't met, then mapping reads on the query set is likely to
> give more accurate results.  [SRST2](https://github.com/katholt/srst2) is the
> perfect tool to do just that.


## Installation

Apart from `blastn` and `makeblastdb`, `sast` uses software that is present on
any GNU system, and most POSIX systems.  You may need to install:

* `gawk` (GNU awk), and/or set environment variable `SAST_GAWK` to its location
* `sed`, and/or set environment variable `SAST_SED` to its location
* `file`, and/or set `SAST_FILE`to its location
* `blastn` or set `SAST_BLASTN`, and `makeblastdb` which normally comes with it

Installation requires no special installation steps.  Simply clone the repo
and run the `sast` script located in it:

    git clone https://github.com/zwets/sast.git
    sast/sast --help


## Usage

See `sast --help` for instructions and a concise specification of file formats
(recapitulated below).

Some examples:

@@TODO@


## File formats

From `sast --help`:

```
Each GENOME file must be (optionally compressed) FASTA containing assembled
contigs.  Its file name minus extension is used as the genome identifier in
sast's output.  If your file names are ugly, ln(1) is for you.

The ALLELES file must be FASTA, and may list any number of alleles for any
number of genes.  Each allele must have a sequence header with format
'>GDN X', where G is the gene name (a sequence of arbitrary characters),
D is a delimiter (any single non-numeric character), and N is the allele
number (numeric and unique relative to G).  X is optional arbitrary text.

This convention means that you can use most standard allele files (e.g. from
PubMLST or Pasteur, or those that work with SRST2) without modification.
Note how e.g. `rpoB_1`, `blaCTX-M-15`, and `RS31795r7` all comply, and refer to
alleles 1, 15, and 7 of genes `rpoB`, `blaCTX-M`, and `RS31795` respectively.

TABLE must be a TSV file whose first column gives the ST identifier (any string
of characters) for the allele number combination in the remaining columns.  Its
header must specify the gene name corresponding to each column (matching the "G"
part in the allele headers); the first column header is used as the header for
the sequence type column in the `sast` output.
```

---

### License

sast - Simple Assembly Sequence Typing  
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

