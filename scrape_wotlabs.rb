# -*- coding: utf-8 -*-
# URLにアクセスするためのライブラリの読み込み
require 'net/http'
# Nokogiriライブラリの読み込み
require 'nokogiri'

def getStats(table)
  return table.css('tr').map{|node| node.css('td')[1].inner_text}.slice(1, 14)
end

def getTable(doc)
  return doc.xpath('//*[@id="tankerStats"]/table[@class="gridtable generalStats"]')
end

def scrape(name)
  html = Net::HTTP.get('wotlabs.net', '/sea/player/' + name)
  doc = Nokogiri::HTML(html)
  table = getTable(doc)
  stats = getStats(table)
  p (stats.unshift(name)).join("\x09")
end

# ['bloodysnowx'].each do |name|
['bloodysnowx', 'ehou_maki', 'khiro256', 'LOHZ', 'mamastan', 'cocota24', 
 'DForrester', 'watashiehou', 'mikoshi_fighter', 'okaotank', 'lower_animals',
 'wilkatz'].each do |name|
  scrape(name)
end
