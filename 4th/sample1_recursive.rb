#! /usr/local/bin/ruby

def dirlist(dir)
  d = Dir.open(dir)
  d.each do |f|
    p f
  end
  d.close
end

dirlist(ARGV.shift)
