# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

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
      next if run[:status] != 'completed'
      conclusion = run[:conclusion]
      loog.debug("Workflow run '#{run[:name]}' in #{@repo} is '#{conclusion}'")
      if conclusion == 'failure'
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
