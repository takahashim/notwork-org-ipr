# Rubyではじめるインターネットプログラミング

## 第2回 HTTP

No.39 (2000年6月28日発売)に掲載

### 記事の目次

*   まえがき
*   前回のおさらい
*   HTTPを見る
*   RubyのHTTPライブラリ
*   Hypertext Transfer Protocol -- HTTP/1.1
*   RubyのHTTPライブラリその2(http-access)
*   HTML
*   HTML関連ライブラリ
*   おわりに

### モニタリングユーティリティ

*   [httprequestview.rb](httprequestview.rb) ユーザエージェントから送られたHTTPの要求をHTML形式で返すサーバ．
*   [leakproxy.rb](leakproxy.rb) ユーザエージェントとプロクシの間に入り，中継内容を標準出力にダンプする．

### ユーザエージェント

これらは要[uri.rb](http://www.ruby-lang.org/en/raa-list.rhtml?name=uri.rb)．

*   [httpget-nh.rb](httpget-nh.rb) 前回の[httpget.rb](../1st/httpget.rb)をNet::HTTPで書き直したもの．
*   [httpget-nh2.rb](httpget-nh2.rb) [httpget-nh.rb](httpget-nh.rb)の改良版． レスポンスを処理し，[<URL:http://www.ruby-lang.org/>](http://www.ruby-lang.org/)にも エラー無しでアクセスできるようになった．
*   [httpget-nh3.rb](httpget-nh3.rb) [httpget-nh.rb](httpget-nh.rb)の別の改良版． プロクシに対応し，レスポンスで例外を上げない`HTTP#get2`を使って アクセス．
*   [httphead.rb](httphead.rb) GETではなくHEAD要求を出す．
*   [httpget-ha.rb](httpget-ha.rb) 前回の[httpget.rb](../1st/httpget.rb)をHTTPAccessで書き直したもの． 要[http-access](http://www.ruby-lang.org/en/raa-list.rhtml?name=http-access)．

### HTTP

*   [location.rb](location.rb) 引数で指定された固定URIにリダイレクトさせるだけのサーバ．

### HTML

*   [my-html-parser.rb](my-html-parser.rb) SGMLPerserを使ってHTML文書の各A要素の属性とその値を表示する例． 要[html-perser](http://www.ruby-lang.org/en/raa-list.rhtml?name=html-parser)．
*   [simplehtmlperse-sample.rb](simplehtmlparse-sample.rb)
*   [simplehtmlperse-sample2.rb](simplehtmlparse-sample2.rb) SimpleHtmlPerseを使ってHTML文書の各A要素のHREF属性と各IMG要素のSRC属性を 抜き出す例． 要[SimpleHtmlPerse](http://arika.org/ruby/SimpleHtmlParse.html)
*   [tagiter-sample.rb](tagiter-sample.rb) tagiterを使って[Infoseek](http://www.infoseek.co.jp)の検索結果を 解析する例([<URL:http://www.threeweb.ad.jp/~nyasu/software/ruby.html#tagiter>](http://www.threeweb.ad.jp/~nyasu/software/ruby.html#tagiter)にあるものの改造版)． 要[tagiter](http://www.ruby-lang.org/en/raa-list.rhtml?name=tagiter)．

### その他

*   [rfclength.rb](rfclength.rb) rfc-index.txtの各項目を調べてファイルサイズの大きい順にRFC番号と バイト数を表示する．
*   [rfclength2.rb](rfclength2.rb) 上の[rfclength.rb](rfclength.rb)の高速化版．

