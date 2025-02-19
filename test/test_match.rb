# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'loog'
require_relative '../lib/fief/match'

# Test for Match.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class TestMatch < Minitest::Test
  def test_positive
    loog = Loog::NULL
    opts = { include: [], exclude: [] }
    assert Fief::Match.new(opts, loog).matches?('foo/bar')
  end

  def test_negative
    loog = Loog::NULL
    opts = { include: ['*/*'], exclude: ['foo/*'] }
    assert !Fief::Match.new(opts, loog).matches?('foo/bar')
  end
end
