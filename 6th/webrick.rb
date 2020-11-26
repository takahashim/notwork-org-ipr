#!/usr/local/bin/ruby
#
# WEBrick -- WEB server toolkit like bricks.
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi, GOTOU YUUZOU
#
# $Id: webrick.rb,v 1.8 2000/10/26 17:49:17 gotoyuzo Exp $

require 'config'
require 'log'
require 'httputils'
require 'httprequest'
require 'httpresponse'
require 'httpserver'
require 'serverutils'
require 'optparse'

if __FILE__ == $0
  ## main
  ## オプションの処理
  $0 = File.basename($0)
  config_file = nil
  ARGV.options { |q|
    q.banner = "Usage: #{$0} [options]\n"
    q.on('--help', '-h', 'show help') do
      HTTPServer.usage()
      exit 0
    end
    q.on('--config-file=FILE', '-fFILE', String, 'config. file') do |i|
      config_file = i
    end
    q.parse!
  }
  WEBrick::Config.load(config_file)

  include WEBrick

  class FatalError < StandardError; end
  trap('INT') { exit }
  trap('QUIT'){ exit }
  trap('HUP') { raise FatalError, 'signal HUP received.'}
  trap('PIPE'){}
  
  WEBrick.start_server(Config::Port){ |sock|
    HTTPServer.start(sock)
  }
end
