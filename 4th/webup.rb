#! /usr/local/bin/ruby

# �ۡ���ڡ�����������Ƥ���ǥ��쥯�ȥ����� �����Ǥ� ~/public_html
HomePageDir = File.expand_path('~/public_html')
# ����Υ��åץ��ɻ��֤���¸����ե�����̾
UploadTimeFile = 'upload_time.txt'
UploadTimeFileFullpath = HomePageDir + '/' + UploadTimeFile

Host =     '�ۥ���̾�����'                   # ftp.hp1.hoge-domain.jp �ʤ�
User =     '�桼��̾�����'                   # ftpuser �ʤ�
Password = '�ѥ���ɤ����'                 # �嵭�桼���ѥѥ����
TopDir =   'HTML �Υȥåץǥ��쥯�ȥ�����'  # htdocs �� html �ʤ�

# �������åץ��ɥե�������̤��뤿��ˡֻ��֡פ�Ȥ����
UploadTime = if File.exist? UploadTimeFileFullpath
	       Time.at(File.mtime(UploadTimeFileFullpath))
	     else
	       Time.now - 3600 * 24 * 7
	     end

# �����ե�����̾�򽸤��
require 'find'

files = []
Find.find(HomePageDir) {|f|
  if /(~|,v|.bak|\#)$/ =~ f or	      # ��~ ,v .bak #�פǽ����ե�����̾�ϥѥ�
      UploadTime > File.mtime(f) or   # �Ť��ե�����ϥѥ�
      f == UploadTimeFileFullpath     # ������¸�ե�����ϥѥ�
    next
  end

  files.push(f)
}

exit if files.size <= 0		# ���åץ��ɤ���ե����뤬�ʤ����Ͻ�λ

files.sort!

require 'net/ftp'
include Net

ftp = FTP.open(Host, User, Password)           # ��³
ftp.chdir(TopDir)		               # HTML �ȥåץǥ��쥯�ȥ��

for f in files
  t = f.sub(HomePageDir + File::Separator, '') # ftp ��Υѥ�̾�ȹ�碌��
  next if f == HomePageDir
  print f, "\n"			               # ��ǧ�Τ���

  if File.directory? f		               # �ǥ��쥯�ȥ�ʤ�
    if ftp.dir(t).size == 0                    # ftp ��˥ǥ��쥯�ȥ꤬�ʤ�?
      ftp.mkdir(t)                             # ����
    end
  else
    ftp.putbinaryfile(f, t, 512)               # �ե�����ž��(PPP ��³������˾������)
  end
end

ftp.quit
ftp.close

f = File.open(UploadTimeFileFullpath, 'w')
f.print Time.now.ctime, "\n"                   # ���֤���¸
f.close

exit
