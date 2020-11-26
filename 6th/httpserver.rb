#!/usr/local/bin/ruby
#
# httpserver.rb -- HTTPServer Class
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi, GOTOU YUUZOU
#
# $Id: httpserver.rb,v 1.14 2000/10/26 17:49:16 gotoyuzo Exp $

require 'thread'
require 'socket'

require 'config'
require 'log'
require 'httprequest'
require 'httpresponse'
require 'httputils'

module WEBrick
  class HTTPServer
    include HTTPUtils
    include HTTPStatus

    attr_reader :socket
    attr_accessor :request
    attr_accessor :response

    def HTTPServer.start(socket)
      svr = self.new(socket)
      svr.start
    end

    def initialize(socket)
      @serverName = Config::ServerName
      @socket   = socket
      @request  = nil
      @response = nil
    end

    def start
      while true
        @request = HTTPRequest.new(@socket)
        return unless @request.parse
        if @request.status != RC_OK
          @response = make_error_response(@request)
          @response.send_response
          return
        end

        # メソッドに応じた処理を行なう
        begin
          status = content_handler(@request)
        rescue
          status = RC_INTERNAL_SERVER_ERROR
        end

        if status != RC_OK
          return
        end

        if @request.http_version.to_f < 1.1 || 
           @request['connection'] == 'close'
          return
        end
      end
    end

    def content_handler(request)
      # do_<method> が定義されていれば呼び出す
      meth = 'do_' + request.method
      if self.respond_to?(meth)
        self.send(meth, request)
      else
        # 定義されていなければ
        # Not Implemented (501) を返す
        @request.status = RC_NOT_IMPLEMENTED
        res = make_error_response(@request)
        res.send_response
      end
    end

    def do_GET(request)
      filepath = mk_local_name(request.path)
      if File::readable?(filepath)
        res = HTTPResponse.new(@socket)
        res.mimetype = mime_types(filepath)
        res.body = open(filepath).read
        res.send_response
      else
        request.status = RC_NOT_FOUND
        res = make_error_response(@request)
        res.send_response
      end
    end

    def make_error_response(req, message = nil)
      res = HTTPResponse.new(req.io)
      res.mimetype = ['text','html']
      enum = req.status
      serverName = @serverName
      short_msg = HTTPStatus.message(enum)
      if !message
        message = ''
      end
      res.body = <<-EOB
<html>
  <head>
    <title>Error: #{enum} #{short_msg}</title>
  </head>
  <body>
    <h1>#{enum} #{short_msg}</h1>
    <p>
      #{message}
    </p>
    <hr>
    <address>#{serverName}</address>
  </body>
</html>
        EOB
      res
    end

  end
end
