# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/fief/mask'

# Test for Mask.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class TestMask < Minitest::Test
  def test_positive
    assert Fief::Mask.new('*/*').matches?('foo/bar')
    assert Fief::Mask.new('test/*').matches?('Test/one')
    assert Fief::Mask.new('test/hello').matches?('test/Hello')
  end

  def test_negative
    assert !Fief::Mask.new('*/*').matches?('some text')
    assert !Fief::Mask.new('test/*').matches?('best/two')
    assert !Fief::Mask.new('test/hello').matches?('test/hello2')
  end
end
