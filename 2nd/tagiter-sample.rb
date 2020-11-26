#!/usr/bin/env ruby

require 'tagiter'
require 'nkf'

# 結果を保存するためのクラス
class InfoSeekResult
  def initialize(title, url, summary)
    @title, @url, @summary = title, url, summary
  end

  def output
    print "Title : #{@title}\n"
    print "URL   : #{@url}\n"
    print "#{@summary}\n\n"
  end
end

f = open(ARGV[0], "r")
data = f.read           # ファイル全体を読み込む
f.close

results = Array.new
p = TextTagIterator.new(data)

# 始めと終わりに現れるコメントの対応を取る
p.each_block("!-- START ResURL_Search_JW", "!-- END ResURL_Search_JW"){ |res|
  title, url, sum = nil, nil, nil
  res.first("A"){ |anchor|                     # 最初に現れる A タグ
    url = anchor.attributes["HREF"]
    title = anchor.get_first("font").text
  }.next("FONT"){ |summary|                    # 次に現れる FONT タグ
    sum = summary.text
  }
  results.push InfoSeekResult.new(title, url, sum) # 結果を保存する
}

results.each {|res| res.output }               # 出力
