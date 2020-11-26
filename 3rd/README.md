# Rubyではじめるインターネットプログラミング

## 第3回 Telnet

No.40 (2000年8月24日発売)に掲載

### 記事の目次

*   はじめに
*   ブロックとローカル変数
*   TELNETプロトコル
*   標準添付ライブラリ telnet.rb
*   nif.rb の紹介
*   セキュリティ
*   おわりに
*   参考資料
*   コラム RubyとCGI

### モニタリングユーティリティ

*   [leakproxy.rb](leakproxy.rb) - ユーザエージェントとプロクシの間に入り，中継内容を標準出力にダンプする． [前作](../2nd/leakproxy.rb)の改良版で，カスタマイズ出来るように クラス化した．
*   [parse\_telnet.rb](parse_telnet.rb) - leakproxy.rbを使ったTELNETに特化したモニタ．

### telnet.rb の利用例

*   [telnet\_new.rb](telnet_new.rb) - _Net::Telnet::new_のオプション(net/telnet.rbより抜粋)．
*   [nif\_sample1.rb](nif_sample1.rb) - nif.rb の利用例(要nif.rb)．
*   [nif\_logcut.rb](nif_logcut.rb) - nif\_sample1.rb 等のログの利用例(要nif.rb)．

### スレッドとローカル変数の関係

*   [scopetest.rb](scopetest.rb) - ローカル変数のスコープとブロックの関係．
*   [th0.rb](th0.rb) - 一見うまく動いているように見えるスレッド．
*   [th1.rb](th1.rb) - [th0.rb](th0.rb)の弱点を露呈させる例．
*   [th2.rb](th2.rb) - スコープを使った[th2.rb](th2.rb)の改良．
*   [th3.rb](th3.rb) - Queueを使った[th2.rb](th2.rb)のやや偏執的な改良．
*   [th4.rb](th4.rb) - Ruby 1.5 以降の場合．

### コラム RubyとCGIより

*   [simplebbs.rb](simplebbs.rb) 簡易な BBS CGI．
