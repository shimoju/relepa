#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)
require 'active_support/core_ext'

date_range = Time.now.all_week
client = Octokit::Client.new(access_token: ENV['GITHUB_API_TOKEN'])

puts "#{date_range.first.strftime('%Y/%m/%d')} 今週のリリースノート (SUZURI)"
ARGV.each do |repo|
  puts "[*** #{repo}]"
  client.
    pull_requests(repo, state: 'closed', sort: 'updated', direction: 'desc').
    select { |pull|
      date_range.include? pull.merged_at
    }.
    reverse.
    each { |pull|
      puts "🎉 [#{pull.html_url} #{pull.title}] by [#{pull.user.login}.icon] #{pull.merged_at.localtime.strftime('%Y/%m/%d %H:%M')}"
      puts pull.body.sub(/#+ 何を解決するのか\s*/, '').sub(/#+ 変更点.*/m, '').gsub(/^/, '>')
      puts
    }
    puts
end
