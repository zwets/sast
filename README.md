# sast - Simple Assembly Sequence Typing

## Introduction

`sast` is a generic sequence typer for assembled genomes.

`sast` can do MLST, but also resistance, virulence, or serotyping.  It is
generic in that you give it a set of genes of interest (in the form of a
list of alleles for each gene), a table mapping allele combinations to
sequence types, and a collection of genomes.  `sast` then produces the
_(genome x gene)_ matrix of alleles found, and the mapping of each allele
combination on a sequence type.

`sast` does with assemblies what [SRST2](https://github.com/katholt/srst2)
does with reads.


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

