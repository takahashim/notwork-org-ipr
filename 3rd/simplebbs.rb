#!/usr/local/bin/ruby
# SimpleBBS

require 'cgi'
require 'pstore'

## �������
$dbfile = '/tmp/tmpdb.db'
$num = 10  ## ���٤�ɽ��������ܿ�
$InputErrorURL = 'http://localhost/'
$ErrorURL = 'http://localhost/'

class SimpleCGI < CGI
  class InvalidInput < StandardError; end

  def param2(key, default='')
    if self.params[key][0] == ''
      default
    else
      self.params[key][0]
    end
  end

  def bbs_header(title = 'SimpleBBS')
    "<h2>#{title}</h2>"
  end

  def bbs_footer(owner = 'SimpleBBS')
    "</pre><hr>\nby #{owner}"
  end

  def input_form
    self.form('POST','./simplebbs.rb'){
      '̾��: <input name=name><br>'+
      '��̾: <input name=subj><br>'+
      '<textarea name=content rows=5 cols=70>'+
      '</textarea><br><input type="submit">'
    }
  end

  def articles(arts, n)
    "<pre>" +
    arts[-n, n].reverse.collect{|art|
      "<hr><font color=red>" +
      "#{art['name']}</font> <b>"+
      "#{art['subj']}</b>"+
      "#{art['date']}\n#{art['content']}"
    }.join('')
  end
end

begin
  cgi = SimpleCGI.new('html3')
  db  = PStore.new($dbfile)

  ## form�ɤ߹���
  name     = cgi.param2('name','')
  subj     = cgi.param2('subj','(̵��)')
  content  = cgi.param2('content','')
  now_date = Time.now()

  articles = []
  db.transaction {
    ## �����
    if !db.root?('articles')
      db['articles'] = Array.new()
    end
    ## �ǡ�����¸
    if content != nil and content != ''
      if name == ''
        raise SimpleCGI::InvalidInput
      else
        db['articles'] << {
          'name'=>name,
          'date'=>now_date,
          'subj'=>subj,
          'content'=>content
        }
      end
    end
    ## �ɤ߹���
    articles = db['articles']
  }

  ## ɽ��
  cgi.out({
            'type'=>'text/html',
            'charset'=>'shift_jis',
          }) do
    cgi.html() do
      cgi.head(cgi.title{'simplebbs'}) +
        cgi.body() {
        cgi.bbs_header() +
          cgi.input_form + 
          cgi.articles(articles, $num) + 
          cgi.bbs_footer()
      }
    end
  end
rescue SimpleCGI::InvalidInput
  cgi.out({
            'status' => 'REDIRECT',
            'location' => $InputErrorURL
          }){''}
rescue
  cgi.out({
            'status' => 'REDIRECT',
            'location' => $ErrorURL
          }){''}
end
