# Copyright (c) 2023 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
