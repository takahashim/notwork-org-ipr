#!/usr/local/bin/ruby
#
# log.rb -- Log Class
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi
#
# $Id: log.rb,v 1.8 2000/10/26 17:49:17 gotoyuzo Exp $

module WEBrick

  class Log

    # log-level constant
    FATAL = 1
    INFO  = 3
    DEBUG = 5

    attr_accessor :level

    def initialize(filename, level = INFO)
      @log = nil
      if filename.kind_of? String
	@log = open(filename, "a+")
      else
	@log = filename
      end
      @level = level
      @log.write "[#{Time.now.localtime}] start.\n"
    end

    def log(level, msg = "(nothing)")
      if level <= @level
	@log.write "[#{Time.now.localtime}] #{msg}\n"
      end
    end

    def close()
      @log.write "[#{Time.now.localtime}] end.\n"
      @log.close
    end
  end
end

if __FILE__ == $0
  include WEBrick

  tmpfile = 'tmp.tmp'
  begin
    if FileTest.exist? tmpfile
      raise 'tmpfile exists.'
    end
    log = Log.new(tmpfile, Log::INFO)
    log.log Log::INFO, "test,"
    log.log Log::DEBUG, "test,"
    log.log Log::FATAL, "and test."
    log.close

    ## print tmpfile
    print "tmpfile is:\n"
    print open(tmpfile).read
  ensure
    File.delete(tmpfile)
  end
end
