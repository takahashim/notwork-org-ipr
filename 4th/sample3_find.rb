#! /usr/local/bin/ruby

require 'find'

Find.find('/tmp') do |f|
  Find.prune if File.directory?(f) && File.symlink?(f)
  print f, "\n"
end
