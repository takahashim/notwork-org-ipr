#!/usr/bin/env ruby

require 'tagiter'
require 'nkf'

# ��̤���¸���뤿��Υ��饹
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
data = f.read           # �ե��������Τ��ɤ߹���
f.close

results = Array.new
p = TextTagIterator.new(data)

# �Ϥ�Ƚ����˸���륳���Ȥ��б�����
p.each_block("!-- START ResURL_Search_JW", "!-- END ResURL_Search_JW"){ |res|
  title, url, sum = nil, nil, nil
  res.first("A"){ |anchor|                     # �ǽ�˸���� A ����
    url = anchor.attributes["HREF"]
    title = anchor.get_first("font").text
  }.next("FONT"){ |summary|                    # ���˸���� FONT ����
    sum = summary.text
  }
  results.push InfoSeekResult.new(title, url, sum) # ��̤���¸����
}

results.each {|res| res.output }               # ����
