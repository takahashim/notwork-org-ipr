# Rubyではじめるインターネットプログラミング

## 第4回 FTP

No.41 (2000年9月24日発売)に掲載

### 記事の目次

*   はじめに
*   FTPの歴史
*   FTPの特徴
    *   Ethereal
    *   Passiveモード
    *   FTPのコマンド
    *   表現タイプ
*   net/ftp.rb の紹介
*   net/ftpの応用
    *   Fetchクラス
    *   HTML ファイルのアップロード
    *   ファイルをすべて get
*   さらにFTPについて
*   おわりに
*   参考資料
*   コラム find.rb の使い方
    *   簡単な使い方
    *   あるディレクトリの下をパスする方法
*   コラム 再帰処理
    *   考え方
    *   ディレクトリを確認

### FTPの使い方

*   [ftp\_sample1.rb](ftp_sample1.rb) - リモートホストのログインディレクトリの一覧を表示する
*   [ftp\_sample2.rb](ftp_sample2.rb) - 指定した資源をGETする
*   [ftp\_sample3.rb](ftp_sample3.rb) - 指定した資源の種別やサイズを調べる
*   [ftp\_sample4.rb](ftp_sample4.rb) - ディレクトリを再帰的に降下しリストを表示する

### Fetch

*   [fetch.rb](fetch.rb) - 汎用のファイル取得クラス。FTPとHTTPに対応。指定されたURLをGETする。

### FTPの実用アプリケーション

*   [allget.rb](allget.rb) - 指定されたディレクトリ以下のファイルをすべてGETする。
*   [webup.rb](webup.rb) - 更新されたファイルをすべてWebサイトにPUTする。

### コラム find.rb の使い方より

*   [sample1\_find.rb](sample1_find.rb) - "/tmp" 以下のすべてのファイル名を表示する。
*   [sample2\_find.rb](sample2_find.rb) - "/tmp" 以下の100kバイト以上のファイルの名前とサイズをすべて表示する。
*   [sample3\_find.rb](sample3_find.rb) - シンボリックリンクされたディレクトリをスキップする。

### コラム 再帰処理より

*   [sample1\_recursive.rb](sample1_recursive.rb) - 指定されたディレクトリにあるすべてのエントリを `p` する。
*   [sample2\_recursive.rb](sample2_recursive.rb) - 指定されたディレクトリ以下にあるエントリをすべて `p` する。
