#! /usr/local/bin/ruby

# ホームページを管理しているディレクトリを指定 ここでは ~/public_html
HomePageDir = File.expand_path('~/public_html')
# 前回のアップロード時間を保存するファイル名
UploadTimeFile = 'upload_time.txt'
UploadTimeFileFullpath = HomePageDir + '/' + UploadTimeFile

Host =     'ホスト名を指定'                   # ftp.hp1.hoge-domain.jp など
User =     'ユーザ名を指定'                   # ftpuser など
Password = 'パスワードを指定'                 # 上記ユーザ用パスワード
TopDir =   'HTML のトップディレクトリを指定'  # htdocs や html など

# 新規アップロードファイルを識別するために「時間」をとりだす
UploadTime = if File.exist? UploadTimeFileFullpath
	       Time.at(File.mtime(UploadTimeFileFullpath))
	     else
	       Time.now - 3600 * 24 * 7
	     end

# 新規ファイル名を集める
require 'find'

files = []
Find.find(HomePageDir) {|f|
  if /(~|,v|.bak|\#)$/ =~ f or	      # 「~ ,v .bak #」で終わるファイル名はパス
      UploadTime > File.mtime(f) or   # 古いファイルはパス
      f == UploadTimeFileFullpath     # 時間保存ファイルはパス
    next
  end

  files.push(f)
}

exit if files.size <= 0		# アップロードするファイルがない場合は終了

files.sort!

require 'net/ftp'
include Net

ftp = FTP.open(Host, User, Password)           # 接続
ftp.chdir(TopDir)		               # HTML トップディレクトリへ

for f in files
  t = f.sub(HomePageDir + File::Separator, '') # ftp 先のパス名と合わせる
  next if f == HomePageDir
  print f, "\n"			               # 確認のため

  if File.directory? f		               # ディレクトリなら
    if ftp.dir(t).size == 0                    # ftp 先にディレクトリがない?
      ftp.mkdir(t)                             # 作成
    end
  else
    ftp.putbinaryfile(f, t, 512)               # ファイル転送(PPP 接続を前提に小さめに)
  end
end

ftp.quit
ftp.close

f = File.open(UploadTimeFileFullpath, 'w')
f.print Time.now.ctime, "\n"                   # 時間の保存
f.close

exit
