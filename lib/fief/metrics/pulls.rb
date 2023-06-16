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

# Pulls in one GitHub repository.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class Fief::Pulls
  def initialize(api, repo, opts)
    @api = api
    @repo = repo
    @opts = opts
  end

  def take(loog)
    json = @api.pull_requests(@repo, state: 'open')
    total = json.count
    loog.debug("Found #{total} open pull requests in #{@repo}")
    old = 0
    older = 0
    json.each do |pr|
      num = pr[:number]
      data = @api.pull_request(@repo, num)
      if data[:created_at] < Time.now - (60 * 60 * 24 * old_days)
        loog.debug("PR #{@repo}/##{num} is old")
        old += 1
      end
      if data[:created_at] < Time.now - (60 * 60 * 24 * older_days)
        loog.debug("PR #{@repo}/##{num} is very old")
        older += 1
      end
    end
    [
      {
        title: 'Pulls',
        value: total,
        alert: false,
        legend: 'currently open pull requests'
      },
      {
        title: 'Pulls+',
        value: old,
        alert: older > total * 0.4,
        legend: "pull requests open for more than #{old_days} days"
      },
      {
        title: 'Pulls++',
        value: older,
        alert: older > total * 0.2,
        legend: "pull requests open for more than #{older_days} days"
      }
    ]
  end

  private

  def old_days
    28
  end

  def older_days
    112
  end
end
