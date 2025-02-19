# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'loog'
require_relative '../lib/fief/repos'

# Test for Repos.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class TestRepos < Minitest::Test
  def test_simple_list
    loog = Loog::NULL
    opts = { include: ['a/b', 'c/d'], exclude: [] }
    assert Fief::Repos.new(opts, nil, loog).all.include?('a/b')
  end

  def test_excludes_some
    loog = Loog::NULL
    opts = { include: ['a/b', 'c/d'], exclude: ['a/*'] }
    assert !Fief::Repos.new(opts, nil, loog).all.include?('a/b')
  end
end
