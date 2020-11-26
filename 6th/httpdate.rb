#!/usr/local/bin/ruby
#
# date.rb -- HTTPDate Module
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi
#
# $Id: httpdate.rb,v 1.9 2000/10/26 17:49:16 gotoyuzo Exp $

# Date.rb   date��HTTP����(RFC1123����)���Ѵ����롣
#
#  HTTP�������㡧 "Thu, 03 Feb 1994 17:09:00 GMT"
#
#  cf. timezone (RFC 822   5.1. SYNTAX)
#
#   zone  =  "UT"  / "GMT"         ; Universal Time
#                                  ; North American : UT
#         /  "EST" / "EDT"         ;  Eastern:  - 5/ - 4
#         /  "CST" / "CDT"         ;  Central:  - 6/ - 5
#         /  "MST" / "MDT"         ;  Mountain: - 7/ - 6
#         /  "PST" / "PDT"         ;  Pacific:  - 8/ - 7
#         /  1ALPHA                ; Military: Z = UT;
#                                  ;  A:-1; (J not used)
#                                  ;  M:-12; N:+1; Y:+12
#         / ( ("+" / "-") 4DIGIT ) ; Local differential
#                                  ;  hours+min. (HHMM)

require 'parsedate.rb'
include ParseDate

module WEBrick

  module HTTPDate

    Timezone = {
    "UT", "+0000",      "GMT","+0000",
    "EST","-0500",      "EDT","-0400",
    "CST","-0600",      "CDT","-0500",
    "MST","-0700",      "MDT","-0600",
    "PST","-0800",      "PDT","-0700",
    "A",  "-0100",      "M",  "-1200",
    "N",  "+0100",      "Y",  "+1200",
    "JST","+0900"       # �ۤ�ȤϤʤ�
    }
  
    def HTTPDate.time2s(d)
      d.gmtime.strftime("%a, %d %b %Y %X GMT")
    end

    def HTTPDate.s2time(str)
      yy, mm, dd, hh, m2, ss, zone = parsedate(str)
     
      if zone
	if Timezone[zone]
	  zone = Timezone[zone]
	end

	if zone =~ /([+-])(\d\d)(\d\d)/
	  hh += ($1+$2).to_i
	  m2 += ($1+$3).to_i
	end
      end
	
      return Time.gm(yy,mm,dd,hh,m2,ss)
    end
  end
end

if __FILE__ == $0

#requre 'httpdate'
  include WEBrick

  # �����RFC1123������ɽ��
  t =  HTTPDate.time2s(Time.now)
  p t

  # �����ʸ�����Time���֥������Ȥ��Ѵ�
  p HTTPDate.s2time(t)
end
