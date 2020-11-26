#!/usr/bin/env ruby

require 'simplehtmlparse'

f = open(ARGV[0], "r")
p = SimpleHtmlParse.new(f)
p.each{ |name, begin_end, attrib, text|
  if name && begin_end == SimpleHtmlParse::TAG_BEGIN
    case name
    when "A"                     # A �����ν���
      if href = attrib['HREF']   # HREF °��
        href.sub!(/#.*/, "") 
        href if href.size > 0
      end
    when "IMG"                   # IMG �����ν���
      attrib['SRC']              # SRC °��
    end
  end
}
f.close

# each ���Ϥ����֥�å���ɾ��������� nil �ʳ��ξ��ϡ���ưŪ��
# �᥽�å� content �ǻ��Ȥ��������˳�Ǽ����롥
p.content.uniq.each { |url|      
  print "#{url}\n"
}
