# Rubyではじめるインターネットプログラミング

## 第6回 サーバ(後編) -- HTTPサーバツールキットWEBrick

2001年1月号 (2000年11月24日発売)に掲載

### 記事の目次

*   はじめに
*   前回のおさらい
    *   なぜサーバを書くのか
*   今回の流れ
*   HTTPについて
    *   HTTPのバージョンについて
    *   メディアタイプ
    *   永続的接続
    *   チャンク形式エンコーディング
    *   バイトレンジリクエスト
    *   Cache-Control
    *   コンテンツネゴシエーション
    *   認証について
*   HTTPサーバを作ろう
    *   名前を付けよう
    *   方針を決めよう
*   WEBrickモジュールの構成
*   WEBrickの使用例
*   まとめ
*   参考資料
*   コラム「複数ポートの待ち受け」

### WEBrickモジュールの構成より

*   [webrick.rb](webrick.rb) - WEBrick全体を読み込むためのファイル
*   [httprequest.rb](httprequest.rb) - 受信したリクエストを管理するためのクラス． new(socket) でオブジェクトの作成， parse() で socketから送られてきたデータの解釈を行っている． 解釈の結果は status()，method()，host()などの 各メソッドで参照する．
*   [httpresponse.rb](httpresponse.rb) - 送信する応答を管理するクラス．Content-Lengthや Content-Typeなど，のエンティティヘッダの調整を自動 的に行なう．生成時に指定されたHTTPRequestのヘッダの 内容による調整も行なう．
*   [httpserver.rb](httpserver.rb) - ソケットから送られてきたデータ列をリクエストとして解釈し， 対応するレスポンスを返す．
*   [httpstatus.rb](httpstatus.rb) - RFC2616で規定されているステータスを取り扱うためのモジュールや， ステータスに対応した例外オブジェクト，メッセージを管理する． ステータスコードとステータスメッセージの関連づけにはHashを 使っている．
*   [httputils.rb](httputils.rb) - パスやURIの解釈など，他に分類しにくいHTTP関係の ユーティリティを提供するモジュール．これらの ユーティリティは HTTPServer クラスなどで使われている．
*   [httpdate.rb](httpdate.rb) - RFC2616で規定されている3種類の日付フォーマットを解釈し， RFC1123フォーマットで出力する機能を提供するモジュール．
*   [serverutils.rb](serverutils.rb) - HTTPとは直接関係しない，サーバの実行に関する部分を 扱うための機能を提供するモジュール．
*   [config.rb](config.rb) - 設定によって変更される変数や定数を管理するため名前空間を 提供するモジュール．WEBrickの設定は WEBrick::Config という モジュール内に全て納める方針になっている．
*   [log.rb](log.rb) - ログ出力機能を提供するクラス．new(filename, level) で ログオブジェクトの生成，log(level，msg)でログの出力， close()でログの終了を行う．

### WEBrickの使用例より

*   [cvsweb.rb](cvsweb.rb) - CVSのリポジトリを参照するWEBサーバのサンプル．

### コラム「複数ポートの待ち受け」より

*   [tiny\_inetd.rb](tiny_inetd.rb) - 簡易版inetd．selectによる接続要求判定のサンプル．
