#!/usr/local/bin/ruby
#
# httprequest.rb -- HTTPRequest Class
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi, GOTOU YUUZOU
#
# $Id: httprequest.rb,v 1.17 2000/10/26 17:49:16 gotoyuzo Exp $

require 'httputils'
require 'httpstatus'
require 'timeout'

module WEBrick

  class HTTPRequest
    include HTTPUtils
    include HTTPStatus

    attr_reader :header, :raw_header
    attr_reader :method, :request_uri, :http_version
    attr_reader :body
    attr_reader :io
    attr_accessor :status
    attr_accessor :host
    attr_accessor :path
    attr_accessor :query
    attr_accessor :request_timeout

    def initialize(io)
      @io = io
      @header = Hash.new
      @raw_header = Array.new
      @method = nil
      @request_uri = nil
      @http_version = nil
      @body = nil
      @status = nil
      @path = nil
      @request_timeout = nil
    end

    def parse()
      begin
        if read_request_line
          read_header
          case @method
          when "POST", "PUT"
            read_body
          end
          @status = RC_OK
        end
      rescue HTTPStatusError
        @status = $!.code
      end
      return @status
    end

    def read_request_line()
      request_line = nil
      begin
        timeout(@request_timeout){
          request_line = @io.gets
        }
      rescue TimeoutError
        raise RequestTimeoutError
      end

      # if Connection is closed
      return nil unless request_line

      if /(\S+)\s+(\S+)\s+(HTTP\/(\d+\.\d+))?
          #{CRLF}/xo =~ request_line
        @method       = $1
        @request_uri  = $2
        @http_version = $4 || "0.9"
      else
        raise BadRequestError
      end

      uri = parse_uri(@request_uri)
      @host = uri.host || @header['host']
      @path = uri.path
      @query = uri.query

      return true
    end
    private :read_request_line

    def read_header()
      field = nil
      while true
        line = @io.gets(CRLF)
        case line
        when /^([A-Za-z0-9_-]+):(.*)$/o
          field, value = $1, $2
          field.downcase!
          @header[field] = value
        when /^[\t ]+(.*)$/o
          value = $1
          raise BadRequestError unless field
          @header[field] << value
        when CRLF
          break
        else
          raise BadRequestError
        end
        @raw_header << line
      end

      @header.each{ |k, v|
        v.gsub!(/^(#{CRLF})?\s+/o, "")
        v.gsub!(/(#{CRLF})?\s+$/o, "")
        v.gsub!(/(#{CRLF})?\s+/o, " ")
      }
    end
    private :read_header

    def read_body
      if tc = @header['transfer-encoding']
        case tc
        when "chunked"
          @body = read_chunked
        else
          raise NotImplementedError
        end
      elsif @header['content-length'] == nil
        raise LengthRequireError
      else
        size = @header['content-length'].to_i
        @body = @io.read(size)
        if @body == nil || @body.size != size
          raise BadRequestError
        end
      end
    end
    private :read_body

    def read_chunked
      body = ""
      while true
        line = @io.gets(CRLF)
        case line
        when /0#{CRLF}/o        # last-chunk
          break;
        when /^([0-9a-fA-F]+)/o # chunk
          size = $1.hex
          body << @io.read(size)
          @io.read 2            # skip CRLF
        else
          raise BadRequestError
        end
      end
      read_header()             # trailer + CRLF
      body
    end
    private :read_chunked

    def [](field)
      @header[field]
    end
  end
end

if __FILE__ == $0
  include WEBrick
  # サンプル用のレスポンスファイルを開く
  f = open("testrequest.txt","r")

  while true
    # リクエストオブジェクトの生成
    r = HTTPRequest.new(f)

    # リクエストをparseしてstatusがなければ終了
    r.parse()
    break unless r.status 

    # StatusがOKならそれぞれ表示
    if r.status == HTTPStatus::RC_OK
      print "--------\n"
      r.header.keys.each{|k|
        print "#{k}:#{r[k]}\n"
      }
      p r.body
      print "  status : #{r.status.inspect}\n"
      print "  method : #{r.method.inspect}\n"
      print "  host   : #{r.host.inspect}\n"
      print "  path   : #{r.path.inspect}\n"
      print "  query  : #{r.query.inspect}\n"
    end
  end
end
