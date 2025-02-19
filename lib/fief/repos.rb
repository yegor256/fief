# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative 'mask'

# Fetch all repos required by the options.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class Fief::Repos
  def initialize(opts, api, loog)
    @opts = opts
    @api = api
    @loog = loog
  end

  def all
    repos = []
    @opts[:include].each do |mask|
      org, repo = mask.split('/')
      if repo == '*'
        if @api.user(org)[:type] == 'User'
          @loog.debug("GitHub account @#{org} is a user's account")
          @api.repositories(org, { type: 'public' }).each do |json|
            id = json[:full_name]
            if json[:archived]
              @loog.debug("The #{id} repo is archived, ignoring it")
              next
            end
            repos << id
            @loog.debug("Including #{id} as it is owned by @#{org}")
          end
        else
          @loog.debug("GitHub account @#{org} is an organization account")
          @api.organization_repositories(org, { type: 'public' }).each do |json|
            id = json[:full_name]
            if json[:archived]
              @loog.debug("The #{id} repo is archived, ignoring it")
              next
            end
            repos << id
            @loog.debug("Including #{id} as a member of @#{org} organization")
          end
        end
      else
        @loog.debug("Including #{org}/#{repo} as requested by --include")
        repos << mask
      end
    end
    repos.reject do |repo|
      if @opts[:exclude] && @opts[:exclude].any? { |m| Fief::Mask.new(m).matches?(repo) }
        @loog.debug("Excluding #{repo} due to --exclude")
        true
      else
        false
      end
    end
  end
end
