#! /usr/local/bin/ruby

require 'find'

Find.find('/tmp') do |f|
  if File.file?(f) && (size = File.size?(f)) > 100 * 1024
    print f, ' ', size, "\n"
  end
end
