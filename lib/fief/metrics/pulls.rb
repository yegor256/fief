# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

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
