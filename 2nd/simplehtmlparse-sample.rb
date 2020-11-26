#!/usr/bin/env ruby

require 'simplehtmlparse'

f = open(ARGV[0], "r")
p = SimpleHtmlParse.new(f)
p.each{ |name, begin_end, attrib, text|
  if name && begin_end == SimpleHtmlParse::TAG_BEGIN
    case name
    when "A"                     # A タグの処理
      if href = attrib['HREF']   # HREF 属性
        href.sub!(/#.*/, "") 
        href if href.size > 0
      end
    when "IMG"                   # IMG タグの処理
      attrib['SRC']              # SRC 属性
    end
  end
}
f.close

# each に渡したブロックを評価した結果 nil 以外の場合は、自動的に
# メソッド content で参照される配列に格納される．
p.content.uniq.each { |url|      
  print "#{url}\n"
}
