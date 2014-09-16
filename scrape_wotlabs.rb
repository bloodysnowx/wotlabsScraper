# -*- coding: utf-8 -*-
# URLにアクセスするためのライブラリの読み込み
require 'net/http'
# Nokogiriライブラリの読み込み
require 'nokogiri'

def scrape(name)
  p name
  charset = nil
  html = Net::HTTP.get('wotlabs.net', '/sea/player/' + name) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end
  # htmlをパース(解析)してオブジェクトを生成
  doc = Nokogiri::HTML.parse(html, nil, charset)
  table = doc.xpath('//*[@id="tankerStats"]/table[@class="gridtable"]')[2]
  text = ""
  table.css('tr').each do |node|
    text = text + node.css('td')[0].inner_text + ":" + node.css('td')[1].inner_text + ", "
  end
  p text
end

['bloodysnowx', 'ehou_maki', 'khiro256', 'LOHZ', 'mamastan', 'cocota24', 
 'DForrester', 'watashiehou', 'mikoshi_fighter', 'okaotank'].each do |name|
  scrape(name)
end
