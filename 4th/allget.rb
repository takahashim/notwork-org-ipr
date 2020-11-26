#! /usr/local/bin/ruby

def usage
  STDERR.print "usage: " + $0 +
    " hostname topdir\n"
  exit 1
end

def multi_mkdir(mpath)
  print "mkdir #{mpath}\n"
  path = ''
  mpath.split('/').each do |f|
    path.concat(f)
    Dir.mkdir(path) unless File.exist?(path)
    path.concat('/')
  end
end

require 'net/ftp'
include Net

class FTP
  def allget(path)
    multi_mkdir(path)
    self.ls(path).each do |ls_line|
      ls_line.scan(/^(-|d).+?(\S+)$/) do
	|dir, file|
	next if file == '.' || file == '..'
	f = path + '/' + file
	case dir
	when '-'
	  mtime = self.mtime(f)
	  next if File.exist?(f) &&
	    File.mtime(f) >= mtime
	  print "get #{f}\n"
	  self.getbinaryfile(f, f, 4096)
	  File.utime(mtime, mtime, f)
	when 'd'
	  allget(f)
	end
      end
    end
  end
end

User = 'anonymous'
Password = 'name@domain' # E-mail address

usage if ARGV.size != 2

Host = ARGV.shift
TopDir = ARGV.shift.sub(/^\//, '')

Dir.mkdir(Host) unless File.exist?(Host)
Dir.chdir(Host)

ftp = FTP.open(Host, User, Password)

ftp.allget(TopDir)

ftp.quit
ftp.close
