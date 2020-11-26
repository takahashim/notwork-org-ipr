#!/usr/local/bin/ruby
#
# Fetch Class Library

class Fetch
  ## ftp
  begin
    require 'net/ftp'
    include Net
  rescue LoadError
    require 'ftplib'
  end
  
  ## uri
  require 'uri'
  include URIModule

  PARAM = {
    'http_proxy' => ENV['http_proxy'],
    'ftp_proxy'  => ENV['ftp_proxy']
  }
  Chunk_size = 4096

  def initialize()
    @http_proxy = PARAM['http_proxy']
    @ftp_proxy  = PARAM['ftp_proxy']
  end

  attr_accessor :http_proxy
  attr_accessor :ftp_proxy

  def Fetch.fetch(url, chunk_size = Chunk_size, &proc)
    Fetch.new.fetch(url, chunk_size, &proc)
  end

  def fetch(url, chunk_size = Chunk_size, &proc)
    if url.type != String
      raise TypeError, 
	"wrong argument type #{url.inspect} (expected String)"
    end

    ## for HTTP
    if url =~ /^http:/
      fetch_http(url, chunk_size, @http_proxy, &proc)

    ## for FTP
    elsif url =~ /^ftp:/
      if @ftp_proxy
	fetch_http(url, chunk_size, @ftp_proxy, &proc)
      else
	fetch_ftp(url, chunk_size, &proc)
      end

    ## for File
    elsif url =~ /^\/|^\./ || (url !~ /^http:|^ftp:/ && FileTest.exist?(url))
      fetch_file(url, chunk_size, &proc)

    ## Error
    else
      raise TypeError, "wrong argument #{url.inspect}"
    end
  end

  def fetch_file(url, chunk_size)
    if FileTest.file?(url)
      File::open(url){|f|
	if iterator?
	  while data = f.read(chunk_size)
	    yield data
	  end
	else
	  f.read
	end
      }
    else
      data_buf = []
      Dir.foreach(url){|dir|
	if dir != '.' and dir != '..'
	  if iterator?
	    yield dir+"\n"
	  else
	    data_buf << dir
	  end
	end
      }
      data_buf.join("\n")+"\n"
    end
  end

  def fetch_http(url, chunk_size, proxy)
    u = URI.create(url)

    if proxy
      p_url = URI.create(proxy)
      s = TCPSocket.new(p_url.host, p_url.port)
      s.puts "GET #{url} HTTP/1.0\r\nHOST: #{p_url.host}\r\n\r\n"
      s.puts "GET #{url} HTTP/1.0\r\n\r\n"
    else
      s = TCPSocket.new(u.host, u.port)
      s.puts "GET #{u.path} HTTP/1.0\r\nHOST: #{u.host}\r\n\r\n"
    end
    while header = s.gets()
      break if header =~ /^([\r\n])*$/
    end
    if iterator?
      while data = s.read(chunk_size)
	yield data
      end
    else
      data_buf = []
      while data = s.read(chunk_size)
	data_buf << data
      end
      data_buf.join('')
    end
  end

  def fetch_ftp(url, chunk_size)
    ret = nil
    u = URI.create(url)
    u.path =~ /(.*)\/([^\/]*)$/
    path2, filename = $1, $2
    ftp = FTP.new(u.host, u.user, u.password)
    if path2 and path2 != ''
      ftp.chdir(path2)
    end
    if filename and filename != ''
      if iterator?
	ftp.retrbinary("RETR "+filename, chunk_size){|data|
	  yield data
	}
      else
	data_buf = ""
	ftp.retrbinary("RETR "+filename, chunk_size){|data|
	  data_buf.concat(data)
	}
	ret = data_buf
      end
    else
      if iterator?
	yield ftp.nlst.join("\n")+"\n"
      else
	ret = ftp.nlst.join("\n")+"\n"
      end
    end
    ftp.quit
    ret
  end
end

## test

if __FILE__ == $0

  ## instance method with block
  url = ARGV.shift
  ft = Fetch.new()
  ft.fetch(url){|data|
    print data
  }
end
