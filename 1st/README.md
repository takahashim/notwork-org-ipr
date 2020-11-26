# Rubyではじめるインターネットプログラミング

## 第1回 インターネットプログラミングことはじめ

No.38 (2000年4月24日発売)に掲載

### 記事の目次

*   はじめに
*   目標と対象読者について
*   プログラムの実例 -- httpget.rb
*   ネットワークの構造，用語の説明など
*   ソケット
*   C による実装
*   Ruby による Echo サーバ・クライアントの実装
*   ちょっと応用
*   おわりに

### HTTP

*   [httpget.rb](httpget.rb) 指定した HTTP URL をHTTPで取得し、ヘッダも含めて表示する
*   [httpget.c](httpget.c) httpget.rb を C で実装したもの
*   [toy\_http\_server.rb](toy_http_server.rb) 簡単な HTTP サーバ

### DAYTIME

*   [daytime.rb](daytime.rb) DAYTIME クライアント
*   [daytime\_server.rb](daytime_server.rb) DAYTIME サーバ

### ECHO

#### TCP

*   [tcp\_echo.rb](tcp_echo.rb) ECHO クライアント
*   [tcp\_echo\_server\_repeat.rb](tcp_echo_server_repeat.rb) ECHO サーバ (反復型)
*   [tcp\_echo\_server\_concurrent.rb](tcp_echo_server_concurrent.rb) ECHO サーバ (並行型)

#### UDP

*   [udp\_echo.rb](udp_echo.rb) ECHO クライアント (connectしない版)
*   [udp\_echo\_by\_connect.rb](udp_echo_by_connect.rb) ECHO クライアント (connectする版)
*   [udp\_echo\_server.rb](udp_echo_server.rb) ECHO サーバ (反復型のみ)

### FTP

*   [getrfc.rb](getrfc.rb) 指定した番号のRFCを取得する

### おまけ

* 「[コラム 制御文](column_control.html)」
 プログラムではありませんが，掲載予定だった「コラム 制御文」です．この コラムは残念ながら紙面の都合で掲載できませんでしたが，同回のp.58でこの コラムについて言及していますのでこの場で公開いたします．
