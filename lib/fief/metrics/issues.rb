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

# Issues in GitHub repo.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class Fief::Issues
  def initialize(api, repo, opts)
    @api = api
    @repo = repo
    @opts = opts
  end

  def take(loog)
    json = @api.list_issues(@repo, state: 'open')
    json.select! { |i| i[:pull_request].nil? }
    total = json.count
    loog.debug("Found #{total} open issues in #{@repo}")
    old = 0
    older = 0
    json.each do |issue|
      num = issue[:number]
      data = @api.issue(@repo, num)
      if data[:created_at] < Time.now - (60 * 60 * 24 * 28)
        loog.debug("Issue #{@repo}/##{num} is old")
        old += 1
      end
      if data[:created_at] < Time.now - (60 * 60 * 24 * 112)
        loog.debug("Issue #{@repo}/##{num} is very old")
        older += 1
      end
    end
    [
      {
        title: 'Open Issues',
        value: total,
        alert: false
      },
      {
        title: 'Old Issues',
        value: old,
        alert: older > total * 0.4
      },
      {
        title: 'Older Issues',
        value: older,
        alert: older > total * 0.4
      }
    ]
  end
end
