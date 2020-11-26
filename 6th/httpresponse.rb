#!/usr/local/bin/ruby
#
# httpresponse.rb -- HTTPResponse Class
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi, GOTOU YUUZOU
#
# $Id: httpresponse.rb,v 1.11 2000/10/26 17:49:16 gotoyuzo Exp $

require 'httputils'
require 'httpdate'
require 'httpstatus'

module WEBrick
  class HTTPResponse
    include HTTPUtils
    include HTTPStatus
    include HTTPDate

    attr_accessor :header
    attr_accessor :http_version, :message
    attr_accessor :mimetype
    attr_accessor :body

    def initialize(io)
      @io = io
      @header = Hash.new()
      @status = RC_OK
      @message = nil
      @mimetype = nil
      @http_version = "1.0"
      @body = ''
    end

    def status=(status, mes=nil)
      @status = status
      @message = mes || message(RC)
    end

    def status
      @status
    end
  
    def [](field)
      @header[field]
    end

    def []=(field, value)
      @header[field] = value
    end

    def send_response()
      if !@mimetype
        # @mimetype = mime_types(@filepath)
      end
      @header['Content-Type'] = @mimetype.join('/')
      if @body
        @header['Content-Length'] = @body.size
      end
      @header['Date'] = HTTPDate.time2s(Time.now)
      send_header()
      send_body()
      @status
    end

    def send_header()
      if !@message
        @message = message(@status)
      end
      @io.write("HTTP/#{@http_version} " +
		"#{@status} #{@message}" + CRLF)
      @header.each{|key, value|
        @io.write "#{key}: #{value}" + CRLF
      }
      @io.write CRLF
    end

    def send_body()
      @body.each{|line|
        @io.write line
      }
    end
  end
end
