#!/usr/local/bin/ruby

require 'webrick'
require 'getopts'
include WEBrick

getopts nil, "d:"       # -d �ǥ�ݥ��ȥ�����

class CVSWeb < WEBrick::HTTPServer
  CVSROOT = $OPT_d
  CVSCMD  = "cvs -d #{CVSROOT} checkout -p"

  unless CVSROOT
    STDERR.print "CVSROOT must be specified.\n"
    exit 2
  end

  # do_GET ����������:
  #  CVSWeb.start -> content_handler -> do_GET�ν�
  #  �˷�ͳ����GET�᥽�åɤ���������ݤ˸ƤФ��
  def do_GET(req)
    rspec, dspec = "HEAD", nil

    # ���������Ϥ���
    if req.query
      req.query.split("&").each{ |q|
        if /^r=([^ \t]+)/ =~ q      
          rspec = $1            # -r <����>
        elsif /^d=([^ \t]+)/ =~ q
          dspec = $1            # -D <����>
        end
      }
    end

    cmd = CVSCMD.dup
    cmd << " -r #{rspec}"
    cmd << " -D #{dspec}" if dspec
    cmd << " #{req.path}"
    data = IO::popen(cmd).read  # �¹�

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
