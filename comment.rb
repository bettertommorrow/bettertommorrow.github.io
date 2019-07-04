username = "jwly101" # GitHub 用户名
new_token = "4977824fb7ba69a1aad5a424a10d015d1e06fea5"  # GitHub Token
repo_name = "gitalk" # 存放 issues
sitemap_url = "http://jwly.cf/sitemap.xml" # sitemap
kind = "Gitalk" # "Gitalk" or "gitment"

require 'open-uri'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'sitemap-parser'

sitemap = SitemapParser.new sitemap_url
urls = sitemap.to_a

conn = Faraday.new(:url => "https://api.github.com/repos/#{username}/#{repo_name}/issues") do |conn|
  conn.basic_auth(username, token)
  conn.adapter  Faraday.default_adapter
end

urls.each_with_index do |url, index|
  title = open(url).read.scan(/<title>(.*?)<\/title>/).first.first.force_encoding('UTF-8')
  response = conn.post do |req|
    req.body = { body: url, labels: [kind, url], title: title }.to_json
  end
  puts response.body
  sleep 15 if index % 20 == 0
end
