#! /usr/local/bin/ruby

require 'find'

Find.find('/tmp') do |f|
  print f, "\n"
end
