<img alt="fief logo" src="/logo.svg" width="64px"/>

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/fief)](http://www.rultor.com/p/yegor256/fief)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/fief/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/fief/actions/workflows/rake.yml)
[![PDD status](http://www.0pdd.com/svg?name=yegor256/fief)](http://www.0pdd.com/p?name=yegor256/fief)
[![Gem Version](https://badge.fury.io/rb/fief.svg)](http://badge.fury.io/rb/fief)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/fief/blob/master/LICENSE.txt)
[![Maintainability](https://api.codeclimate.com/v1/badges/396ec0584e0a84adc723/maintainability)](https://codeclimate.com/github/yegor256/fief/maintainability)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/fief)](https://hitsofcode.com/view/github/yegor256/fief)

This simple script will help you collect statistics about your
GitHub repositories and generate a simple HTML report. First, install it:

```bash
$ gem install fief
```

Then, run it locally and read its output:

```bash
$ fief --repo yegor256/fief --verbose
```

For example, [here is mine](https://yegor256.github.io/fief/).

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
