#!/usr/local/bin/ruby
#
# httputils.rb -- HTTPUtils Module
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi, GOTOU YUUZOU
#
# $Id: httputils.rb,v 1.13 2000/10/26 17:49:17 gotoyuzo Exp $

require 'socket'

module WEBrick
  module HTTPUtils
    ## Constants
    CRLF = "\r\n"
    HTTPMethods = [ "GET", "HEAD", "POST", "OPTIONS",
                    "PUT", "DELETE", "TRACE", "CONNECT" ]

    def mime_types(filename)
      Config::MimeTypes.each{|pat, mtype|
        if pat =~ filename.sub(/\.([^.]+)$/){$1}
          return mtype
        end
      }
      return ['application', 'octet-stream']
    end

    ##
    ## From: shttpsrv.rb by S.Hara
    ##

    def normalize_path(path)
      n_path = path.dup
      # xyz/./abc  => xyz/abc
      n_path.gsub!('/\./', '/')
      # xyz/../abc => abc
      n_path.gsub!(%r|[^/]+/\.\./|, '')
      # xyz/. => xyz/
      n_path.sub!( %r|/\.$|, '/')

      # illegal filespec    
      if %r|^\.\.| =~ n_path
        ## raise HTTPBadRequest,
	##   "recieve illegal name `#{path}'\n"
        n_path.sub!(%r|^(\.\.)+|, '/')
      end
      n_path
    end

    def mk_local_name(name)
      filename = normalize_path(name)
      Config::Alias.each{ |pat, str|
        filename.sub!(pat, str)
      }
      filename = Config::DocumentRoot.sub(%r|/$|, '') +
                 filename.sub(/^\/?/, '/')
      if filename[-1].chr == "/" &&
	  File.directory?(filename)
        Config::DirectoryIndex.each{ |idx|
          if File::file? filename + idx
            filename << "/" + idx
            break
          end
        }
      end
      filename
    end

    # From RFC2396
    #  Appendix B. Parsing URI Reference
    #              with a Regular Expression
    #
    #  The following line is the regular expression
    #  for breaking-down a URI reference into its components.
    #
    #   ^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
    #    12            3  4          5       6  7        8 9
    # ==
    #     scheme    = $2
    #     authority = $4
    #     path      = $5
    #     query     = $7
    #     fragment  = $9

    URI = Struct.new("URI", :scheme, :host, :path, :query)
    def parse_uri(s)
      uri = URI.new
      if %r!^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?! =~ s
        uri.scheme, uri.host, uri.path, uri.query =
	  $2, $4, $5, $7
      end
      uri
    end
  end
end

if __FILE__ == $0
  include WEBrick
  include HTTPUtils
  START_DIR = Dir.pwd
  require 'config.rb'
  p normalize_path("/a")
  p normalize_path("/a/b")
  p normalize_path("/a/./b/c/../d/")
  p normalize_path("/a/")
end
