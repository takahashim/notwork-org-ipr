#!/usr/bin/env ruby

require 'simplehtmlparse'

f = open(ARGV[0], "r")
p = SimpleHtmlParse.new(f)

def p.begin_tag(name, attrib, text)
  case name
  when "A"                      # A タグの処理
    if href = attrib['HREF']    # HREF 属性
      href.sub!(/#.*/, "") 
      content.push(href) if href.size > 0
    end
  when "IMG"                    # IMG タグの処理
    content.push(attrib['SRC']) # SRC 属性
  end
end

p.parse
f.close

p.content.uniq.each { |url|
  print "#{url}\n"
}
