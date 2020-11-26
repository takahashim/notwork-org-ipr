#! /usr/local/bin/ruby

def dirlist(dir)
  d = Dir.open(dir)
  d.each do |f|
    next if f == '.' || f == '..'

    fullpath = dir + '/' + f

    if File.directory?(fullpath)
      dirlist(fullpath)
    else
      p fullpath
    end
  end
  d.close
end

dirlist(ARGV.shift)
