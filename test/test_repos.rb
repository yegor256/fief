require 'loog'
# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/fief/repos'

# Test for Repos.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class TestRepos < Minitest::Test
  def test_simple_list
    assert_includes(Fief::Repos.new({ include: ['a/b', 'c/d'], exclude: [] }, nil, Loog::NULL).all, 'a/b')
  end

  def test_excludes_some
    refute_includes(Fief::Repos.new({ include: ['a/b', 'c/d'], exclude: ['a/*'] }, nil, Loog::NULL).all, 'a/b')
  end
end
