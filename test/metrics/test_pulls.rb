require 'loog'
# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require_relative '../../lib/fief/metrics/pulls'

# Test for Pulls.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class TestPulls < Minitest::Test
  def test_real
    refute_empty(Fief::Pulls.new(Octokit::Client.new, 'yegor256/fief', {}).take(Loog::VERBOSE))
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('GitHub API rate limit exceeded')
  end
end
