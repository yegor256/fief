# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require 'loog'
require_relative '../../lib/fief/metrics/issues'

# Test for Issues.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class TestIssues < Minitest::Test
  def test_real
    api = Octokit::Client.new
    m = Fief::Issues.new(api, 'yegor256/fief', {})
    ms = m.take(Loog::VERBOSE)
    assert !ms.empty?
  rescue Octokit::TooManyRequests => e
    puts e.message
    skip
  end
end
