#! /usr/local/bin/ruby -Ke

require 'nif'

nif = Nifty.new({ 'id' => 'ID を',
                  'password' => 'パスワードを',
                  'Host'     => 'アクセスするホストを',
                  'log' => get_logfile_name })

nif.login{|c| print c}

print "fgalts\n"
nif.pad('pad.fgalts')
nif.forum_read("FGALTS", "1-13,16,17,19,20")

print "flinux\n"
nif.pad("pad.flinux")
nif.forum_read("FLINUX", "ALL")

print "funix\n"
nif.pad("pad.funix")
nif.forum_read("FUNIX", "ALL")

nif.logout{|c| print c}
