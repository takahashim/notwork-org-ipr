# Rubyではじめるインターネットプログラミング

## 第5回 サーバ(前編)

No.42 (2000年9月24日発売)に掲載

### 記事の目次

*   はじめに
    *   今回の流れ
*   なぜサーバを書くのか
    *   永続化
    *   資源的制約
*   サーバプログラムの復習
    *   準備
    *   並行サーバ
        *   スレッドを使った方法(その1)
        *   forkを使った方法(その1)
        *   スレッドを使った方法(その2)
*   デーモンプロセス
    *   デーモンとは
    *   デーモンの作法
    *   まとめ
*   HTTPサーバの基礎
    *   お手本としての CGI/1.1
    *   要求の解析
    *   HTTPサーバの基礎のまとめ
*   今回のまとめ
*   参考資料
*   コラム「ソケットの入出力」
    *   stdio系とsys系
    *   readとsysread
*   コラム「シグナル」(その1)
    *   Rubyのシグナル
    *   UNIX のシグナルモデル
*   コラム「シグナル」(その2)
    *   SIGPIPE

### なぜサーバを書くのかより

*   [lockdir.rb](lockdir.rb) - mkdirを使った排他制御機構の実装例

### サーバプログラムの復習より

*   [http\_test\_stuff.rb](http_test_stuff.rb) - 以降のサーバのテスト用HTTPハンドラ，GETのみを処理する．
*   [httpd\_repeat.rb](httpd_repeat.rb) - 最も単純な反復サーバ
*   [httpd\_thread1.rb](httpd_thread1.rb) - スレッドを使った並行サーバ
*   [httpd\_fork.rb](httpd_fork.rb) - forkを使った並行サーバ
*   [httpd\_thread2.rb](httpd_thread2.rb) - 事前スレッド生成型の並行サーバ，メインスレッドでacceptを行なう．
*   [httpd\_thread3.rb](httpd_thread3.rb) - 事前スレッド生成型の並行サーバ，各スレッドでacceptを行なう．

### デーモンプロセスより

*   [daytime\_server.rb](daytime_server.rb) - [第1回](../1st)で紹介したdaytimeサーバ．メソッドdaemon()のサンプル

### コラム 「ソケットの入出力」より

*   [test\_read.rb](test_read.rb) - TCPSocket#readの動作確認用サーバプログラム
*   [test\_sysread.rb](test_sysread.rb) - TCPSocket#sysreadの動作確認用サーバプログラム
*   [test\_cli1.rb](test_cli1.rb) - 接続後，100000バイトのデータを送信するクライアントプログラム
*   [test\_cli2.rb](test_cli2.rb) - 接続後，1バイトのデータを送信するクライアントプログラム

### コラム 「シグナル」より

*   [sig\_sample0.rb](sig_sample0.rb) - SIGHUPを処理するシグナルハンドラの例

### コラム 「シグナル(その2)」より

*   [sig\_sample1.rb](sig_sample1.rb) - データを1行受信し，1行送信するサーバプログラム
*   [sig\_sample2.rb](sig_sample2.rb) - その1．書き込み時にEPIPEを発生させる例
*   [sig\_sample3.rb](sig_sample3.rb) - その2．読み込み時にEPIPEを発生させる例
*   [sig\_sample4.rb](sig_sample4.rb) - その3．EOFを受け取り正常に終了する例
