#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)

client = Octokit::Client.new(access_token: ENV['GITHUB_API_TOKEN'])
puts client.user.login
