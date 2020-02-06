breezer [![Gem Version](https://badge.fury.io/rb/breezer.svg)](http://badge.fury.io/rb/breezer) [![Build Status](https://travis-ci.org/lambda2/breezer.svg?branch=master)](https://travis-ci.org/lambda2/breezer) [![Code Climate](https://codeclimate.com/github/lambda2/breezer/badges/gpa.svg)](https://codeclimate.com/github/lambda2/breezer) [![Test Coverage](https://codeclimate.com/github/lambda2/breezer/badges/coverage.svg)](https://codeclimate.com/github/lambda2/breezer)
========

A cli to automatically set all your Gemfile dependancies to your current version.

In short
--------

* Updates your Gemfile with your actual used version (from the Gemfile.lock)
* Set if you want to constraint the exact version (ex: = 4.3.2), the patch level (ex: ~> 1.2.3) or the minor level (ex: 1.2).
* Run a check on your Gemfile to ensure all your deps are properly constrained.
* No deps except bundler.

Cli
-----
```bash
Usage: breezer DIR [options]
    -l, --level LEVEL                Set the minimum level of gem updates (default: patch). Set to 'exact' to lock gems versions (not recommended).
    -L, --lockfile NAME              Use different lockfile (default: Gemfile.lock)
    -d, --dry-run                    Print the updated Gemfile instead of writing it
    -o, --output FILE                The output file (default: Gemfile)
    -c, --check                      Check that all gems have version constraints
    -h, --help                       Show this help message
```

Library
-----

```ruby
require 'breezer'

Breezer.freeze!('Gemfile', 'Gemfile.lock', {level: :minor})
```

Requirements
------------

* Bundler 2

Install
-------

* gem install breezer

License
-------

Copyright (C) 2020 André Aubin

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.