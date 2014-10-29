# -*- coding: utf-8 -*-
# URLにアクセスするためのライブラリの読み込み
require 'net/http'
# Nokogiriライブラリの読み込み
require 'nokogiri'

def getStats(table)
  return table.css('tr').map{|node| node.css('td')[1].inner_text}.slice(1, 14)
end

def getTable(doc)
  return doc.xpath('//*[@id="tankerStats"]/table[@class="gridtable generalStats hideMobile"]')
end

def scrape(name)
  html = Net::HTTP.get('wotlabs.net', '/sea/player/' + name)
  doc = Nokogiri::HTML(html)
  table = getTable(doc)
  stats = getStats(table)
  return stats
end

# ['bloodysnowx'].each do |name|
ids = {bloodysnowx: "ちゆき", ehou_maki: "えほう", khiro256: "きいろ", LOHZ: "LOH", mamastan: "まます", cocota24: "ここた", 
 DForrester: "さいころ", watashiehou: "RK12", mikoshi_fighter: "みこし", okaotank: "おかお", lower_animals: "jenga",
  willkatz: "Merkatz", skmswitch: "すきま", jakky2014: "Jakky"}
ids.each do |key, name|
  p key
  p scrape(key.id2name).join("\x09")
end

ids.each do |key, name|
  scraped = scrape(key.id2name)
  p name + " -> " + key.id2name + " : " + scraped[1] + ", " + sprintf("%.2f", scraped[2].to_f / scraped[0].to_f * 100.0) + "%, " + scraped[13]
end
