# -*- coding: utf-8 -*-
# URLにアクセスするためのライブラリの読み込み
require 'net/http'
# Nokogiriライブラリの読み込み
require 'nokogiri'

class WotlabsScraper
  def initialize
    @htmlHash = Hash.new
    @htmlHash.default_proc = -> (hsh, key) { hsh[key] = Net::HTTP.get('wotlabs.net', '/sea/player/' + key) }
  end

  def getStats(table)
    return table.css('tr').map{|node| node.css('td')[1].inner_text}.slice(1, 14)
  end

  def getTable(doc)
    return doc.xpath('//*[@id="tankerStats"]/table[@class="gridtable generalStats hideMobile"]')
  end

  def getHtml(name)
    return @htmlHash[name]
  end

  def scrape(name)
    html = getHtml(name)
    doc = Nokogiri::HTML(html)
    table = getTable(doc)
    stats = getStats(table)
    return stats
  end
end

wotlabsScraper = WotlabsScraper.new

# ['bloodysnowx'].each do |name|
ids = {bloodysnowx: "ちゆき", ehou_maki: "えほう", khiro256: "きいろ", LOHZ: "LOH", mamastan: "まます", cocota24: "ここた", 
 DForrester: "さいころ", watashiehou: "RK12", mikoshi8: "みこし", okaotank: "おかお", lower_animals: "jenga",
  willkatz: "Merkatz", skmswitch: "すきま", jakky2014: "Jakky"}
ids.each do |key, name|
  puts key
  puts wotlabsScraper.scrape(key.id2name).join("\x09")
end

ids.each do |key, name|
  scraped = wotlabsScraper.scrape(key.id2name)
  puts name + " -> " + key.id2name + " : " + scraped[1] + ", " + sprintf("%.2f", scraped[2].to_f / scraped[0].to_f * 100.0) + "%, " + scraped[13]
end
