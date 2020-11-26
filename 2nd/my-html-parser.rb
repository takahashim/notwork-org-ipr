#!/usr/bin/env ruby

require 'sgml-parser'

class MyHTMLParser < SGMLParser
  def start_a(attr)
    attr.each { |attr, value|
      print "#{attr}=#{value}\n"
    }
  end
end

f = open(ARGV[0], "r")
data = f.read
f.close

p = MyHTMLParser.new(true)
p.feed(data)
p.close
