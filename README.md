# bio-old-biofetch-emulator

[![Build Status](https://secure.travis-ci.org/ngoto/bioruby-old-biofetch-emulator.png)](http://travis-ci.org/ngoto/bioruby-old-biofetch-emulator)

Emulator that emulates Bio::Fetch object in BioRuby as if discontinued
BioRuby BioFetch server were still alive. It overrides methods and objects
in Bio::Fetch, and if the old BioRuby BioFetch server's URL is given,
it intercepts all requests and converts them into existing web services
such as TogoWS, KEGG REST API, NCBI E-Utilities, and GenomeNet(genome.jp).

Note: this software may fail to work depending on the status of the above
servers.

## Installation

```sh
gem install bio-old-biofetch-emulator
```

## Usage

```ruby
require 'bio-old-biofetch-emulator'
```

In general, to run existing software using the BioRuby BioFetch server, no
additional code is needed other than `require 'bio-old-biofetch-emulator'`.

The API doc is online. For more code examples see the test files in
the source tree.

## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/ngoto/bioruby-old-biofetch-emulator

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-old-biofetch-emulator)

## Copyright

Copyright (c) 2014 Naohisa Goto. See LICENSE.txt for further details.

