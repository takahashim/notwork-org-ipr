#! /usr/local/bin/ruby -Ke

require 'nifty_article'
require 'nifty_gnus_spool'

def save(f, spool)
  f.each do |forum, f_body|
    spool.set_forum(forum)
    f_body.each do |mes, mes_body|
      spool.set_mes(mes)
      mes_body.split(" \b\n").each do |article|
        next if article == ''
        article_obj = Nifty_article.new(forum, mes, article)
        spool.save_article(article_obj.mk_article)
      end
    end
  end
end

forum = 'junk'
mes = 'junk'
patio = 'junk'
f = {}
f[forum] = {}
f[forum][mes] = ''
spool = Nifty_Gnus_spool.new

while gets
  $_.gsub!(/\r/, '')

  if /^(?:¡ä|CCS\([NP]\)>|LIB>|FORUM>|more>|PATIO\([NP]\)>)GO\s+([FISP]\w+)$/
    forum = $1.downcase
    save(f, spool)
    f = {}
    f[forum] = {}
    f[forum][mes] = ''

    if not f.key?(forum)
      f[forum] = {}
    end
    mes = 'junk'
    patio = 'junk'
    if not f[forum].key?(mes)
      f[forum][mes] = ''
    end
  elsif /^- (\w+)  MES\( ?(\d+)\):(.*?) (\d\d\/\d\d\/\d\d) -$/
    back_forum = forum
    forum = $1.downcase
    mes = $2
    title = $3
    date = $4
    if back_forum != forum
      STDERR.print "miss #{back_forum} #{forum}\n"
    end
    title.gsub!(/[\s¡¡]+/, ' ')
    title.gsub!(/\s+/, ' ')
    print "forum(#{forum}) mes(#{mes}) title(#{title}) date(#{date})\n"
    if not f[forum].key?(mes)
      f[forum][mes] = ''
    else
      f[forum][mes].concat(" \b\n")
    end
  elsif /^(?:¡ä|CCS\([NP]\)>|LIB>|FORUM>|more>|PATIO\([NP]\)>)(?:OFF|BYE)$/ or
      /^CLR DER 208$/ or /^(?:¡ä)\z/
    save(f, spool)
    forum = 'junk'
    mes = 'junk'
    patio = 'junk'
    f = {}
    f[forum] = {}
    f[forum][mes] = ''
  elsif forum == 'patio' and /^¡§(\w{8})$/
    patio = $1.downcase
    print "patio(#{patio})\n"
  elsif /^- MES\(..\):(.*) (\d\d\/\d\d\/\d\d) -/
    mes = patio
    title = $1
    date = $2
    print "forum(#{forum}) mes(#{mes}) title(#{title}) date(#{date})\n"
    if not f[forum].key?(mes)
      f[forum][mes] = ''
    end
  else
    f[forum][mes].concat($_)
    if $. % 50 == 0
      GC.start
    end
  end
end

save(f, spool)
spool.save_active
