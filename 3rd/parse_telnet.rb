#!/usr/bin/env ruby

require 'leakproxy'

class ParseTelnet < LeakProxy
  IAC  = 255.chr # \377 # interpret as command
  DONT = 254.chr # \376 # you are not to use option
  DO   = 253.chr # \375 # please, you use option
  WONT = 252.chr # \374 # I won't use option
  WILL = 251.chr # \373 # I will use option
  SB   = 250.chr # \372 # interpret as subnegotiation
  GA   = 249.chr # \371 # you may reverse the line
  EL   = 248.chr # \370 # erase the current line
  EC   = 247.chr # \367 # erase the current character
  AYT  = 246.chr # \366 # are you there
  AO   = 245.chr # \365 # abort output -- but let prog finish
  IP   = 244.chr # \364 # interrupt process -- permanently
  BRK  = 243.chr # \363 # break
  DM   = 242.chr # \362 # data mark -- for connect. cleaning
  NOP  = 241.chr # \361 # nop
  SE   = 240.chr # \360 # end sub negotiation

  def process_data(data)
    print_headline
    tmp = data.dup

    # TELNETコマンドを抽出しダンプする．
    tmp.gsub!(/#{IAC}(
                 [#{DONT}#{DO}#{WONT}#{WILL}].|
                 #{SB}.(#{IAC}#{IAC}|[^#{IAC}])*#{IAC}#{SE}|
                 [#{NOP}-#{GA}#{0.chr}-#{239.chr}]
             )/xon){
        case $1[0].chr
        when DONT; print "> IAC DONT #{$1[1]}\n"
        when DO  ; print "> IAC DO   #{$1[1]}\n"
        when WONT; print "> IAC WONT #{$1[1]}\n"
        when WILL; print "> IAC WILL #{$1[1]}\n"
        when SB  ; print "> IAC SB   #{$1[1]} #{$1[2..-3].dump} IAC SE\n"
        else     ; print "> IAC #{$1[1]}\n"
        end
    }

    # 残りの部分を出力．
    tmp.each { |line| print line.dump, "\n" } if tmp.size > 0
  end
end

local_port = ARGV[0] || 2323
host       = ARGV[1] || "localhost"
ParseTelnet.new(local_port.to_i, host, "telnet").start
