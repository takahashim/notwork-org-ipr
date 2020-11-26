#!/usr/local/bin/ruby
#
# config.rb -- Config Module
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi, GOTOU YUUZOU
#
# $Id: config.rb,v 1.8 2000/10/26 17:49:15 gotoyuzo Exp $

module WEBrick
  module Config
    START_DIR      = Dir.pwd

    ## Default Settings for WEBrick
    module Defaults
      ## General
      ServerName     = 'WEBrick/0.0.0'
      ConfigFile     = START_DIR + "/conf/config.rb"
      DocumentRoot   = START_DIR + "/htdocs"
      LogFile        = START_DIR + "/log/httpd.log"
      DirectoryIndex = [ 'index.html' ]
      ReequestTimeout = 5

      ## ServerUtils
      Port           = 8080
      ThreadNum      = 5
    end
    include Config::Defaults

    def load(file=nil)
      unless file
        file = Config::Defaults::ConfigFile
      end
      if File::exist?(file)
        config = open(file).read
        Config.module_eval(config)
      end
    end
    module_function :load

  end
end
