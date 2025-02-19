# SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
# SPDX-License-Identifier: MIT

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
      if data[:created_at] < Time.now - (60 * 60 * 24 * old_days)
        loog.debug("Issue #{@repo}/##{num} is old")
        old += 1
      end
      if data[:created_at] < Time.now - (60 * 60 * 24 * older_days)
        loog.debug("Issue #{@repo}/##{num} is very old")
        older += 1
      end
    end
    [
      {
        title: 'Issues',
        value: total,
        alert: false,
        legend: 'сurrently unresolved issues'
      },
      {
        title: 'Issues+',
        value: old,
        alert: older > total * 0.4,
        legend: "issues unresolved for more than #{old_days} days"
      },
      {
        title: 'Issues++',
        value: older,
        alert: older > total * 0.4,
        legend: "issues unresolved for more than #{older_days} days"
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
