# ❄️ Breezer

> [Bundle freezer]

[![Gem Version](https://badge.fury.io/rb/breezer.svg)](http://badge.fury.io/rb/breezer) [![Build Status](https://travis-ci.org/lambda2/breezer.svg?branch=master)](https://travis-ci.org/lambda2/breezer) [![Code Climate](https://codeclimate.com/github/lambda2/breezer/badges/gpa.svg)](https://codeclimate.com/github/lambda2/breezer) [![Test Coverage](https://codeclimate.com/github/lambda2/breezer/badges/coverage.svg)](https://codeclimate.com/github/lambda2/breezer)


A cli to automatically set all your Gemfile dependencies to safe versions.

## In short

* Updates your Gemfile with your actual used version (from the Gemfile.lock)
* Set if you want to constraint the exact version (ex: = 4.3.2), the patch level (ex: ~> 1.2.3) or the minor level (ex: 1.2).
* Run a check on your Gemfile to ensure all your deps are properly constrained.
* No deps except bundler.

![video](./images/demo.gif)

## Cli

```bash
Usage: breezer DIR [options]
    -l, --level LEVEL                Set the minimum level of gem updates (default: patch). Set to 'exact' to lock gems versions (not recommended).
    -L, --lockfile NAME              Use different lockfile (default: Gemfile.lock)
    -d, --dry-run                    Print the updated Gemfile instead of writing it
    -o, --output FILE                The output file (default: Gemfile)
    -c, --check                      Check that all gems have version constraints
    -h, --help                       Show this help message
```

## Library

```ruby
require 'breezer'

Breezer.freeze!('Gemfile', 'Gemfile.lock', {level: :minor})
```

## Requirements

* `bundler`

## Install

* `gem install breezer`

## License

[MIT License](http://www.opensource.org/licenses/mit-license.php)

## Authors

* [André Aubin](https://github.com/lambda2)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Test

```Bash
bundle exec rake test
```

## Release

```Bash
bundle exec rake bump:{patch|minor|major}
bundle exec rake release
```
