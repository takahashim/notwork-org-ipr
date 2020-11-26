#!/usr/bin/env ruby

require 'simplehtmlparse'

f = open(ARGV[0], "r")
p = SimpleHtmlParse.new(f)

def p.begin_tag(name, attrib, text)
  case name
  when "A"                      # A �����ν���
    if href = attrib['HREF']    # HREF °��
      href.sub!(/#.*/, "") 
      content.push(href) if href.size > 0
    end
  when "IMG"                    # IMG �����ν���
    content.push(attrib['SRC']) # SRC °��
  end
end

p.parse
f.close

p.content.uniq.each { |url|
  print "#{url}\n"
}
