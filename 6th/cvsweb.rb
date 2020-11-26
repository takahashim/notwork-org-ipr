#!/usr/local/bin/ruby

require 'webrick'
require 'getopts'
include WEBrick

getopts nil, "d:"       # -d でリポジトリを指定

class CVSWeb < WEBrick::HTTPServer
  CVSROOT = $OPT_d
  CVSCMD  = "cvs -d #{CVSROOT} checkout -p"

  unless CVSROOT
    STDERR.print "CVSROOT must be specified.\n"
    exit 2
  end

  # do_GET を再定義する:
  #  CVSWeb.start -> content_handler -> do_GETの順
  #  に経由してGETメソッドを受信した際に呼ばれる
  def do_GET(req)
    rspec, dspec = "HEAD", nil

    # クエリを解析する
    if req.query
      req.query.split("&").each{ |q|
        if /^r=([^ \t]+)/ =~ q      
          rspec = $1            # -r <タグ>
        elsif /^d=([^ \t]+)/ =~ q
          dspec = $1            # -D <日付>
        end
      }
    end

    cmd = CVSCMD.dup
    cmd << " -r #{rspec}"
    cmd << " -D #{dspec}" if dspec
    cmd << " #{req.path}"
    data = IO::popen(cmd).read  # 実行

    if data
      res = HTTPResponse.new(req.io)
      res.mimetype = [ "text", "plain" ]
      res.body = data
    else
      req.status = RC_NOT_FOUND
      res = make_error_response(req)
    end
    res.send_response
  end
end

WEBrick.start_server(Config::Port){ |sock|
  CVSWeb.start(sock)
}
