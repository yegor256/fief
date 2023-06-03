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

# GitHub Action Runs in one GitHub repository.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2023 Yegor Bugayenko
# License:: MIT
class Fief::Runs
  def initialize(api, repo, opts)
    @api = api
    @repo = repo
    @opts = opts
  end

  def take(loog)
    master = @api.repository(@repo)[:default_branch]
    json = @api.repository_workflow_runs(@repo, branch: master)
    workflows = []
    failures = 0
    json[:workflow_runs].take(32).each do |run|
      workflow = run[:workflow_id]
      next if workflows.include?(workflow)
      workflows << workflow
      status = run[:status]
      loog.debug("Workflow run '#{run[:name]}' in #{@repo} is in status '#{status}'")
      if status == 'failure'
        loog.debug("Workflow run '#{run[:name]}' is failed")
        failures += 1
      end
    end
    [
      {
        title: 'CI failures',
        value: failures,
        alert: failures > 0
      }
    ]
  end
end
