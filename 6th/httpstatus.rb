#!/usr/local/bin/ruby
#
# httpstatus.rb -- HTTPStatus Class
#
# Author: IPR -- Internet Programmming with Ruby -- writers
# Copyright (C) 2000 TAKAHASHI Masayoshi, GOTOU YUUZOU
#
# $Id: httpstatus.rb,v 1.10 2000/10/26 17:49:16 gotoyuzo Exp $

module WEBrick

  module HTTPStatus

    StatusMessage = {
      100, 'Continue',
      101, 'Switching Protocols',
      200, 'OK',
      201, 'Created',
      202, 'Accepted',
      203, 'Non-Authoritative Information',
      204, 'No Content',
      205, 'Reset Content',
      206, 'Partial Content',
      300, 'Multiple Choices',
      301, 'Moved Permanently',
      302, 'Found',
      303, 'See Other',
      304, 'Not Modified',
      305, 'Use Proxy',
      307, 'Temporary Redirect',
      400, 'Bad Request',
      401, 'Unauthorized',
      402, 'Payment Required',
      403, 'Forbidden',
      404, 'Not Found',
      405, 'Method Not Allowed',
      406, 'Not Acceptable',
      407, 'Proxy Authentication Required',
      408, 'Request Timeout',
      409, 'Conflict',
      410, 'Gone',
      411, 'Length Required',
      412, 'Precondition Failed',
      413, 'Request Entity Too Large',
      414, 'Request-URI Too Large',
      415, 'Unsupported Media Type',
      416, 'Request Range Not Satisfiable',
      417, 'Expectation Failed',
      500, 'Internal Server Error',
      501, 'Not Implemented',
      502, 'Bad Gateway',
      503, 'Service Unavailable',
      504, 'Gateway Timeout',
      505, 'HTTP Version Not Supported'
    }

    class HTTPStatusError < StandardError; end
    
    StatusMessage.each{|code, message|
      var_name = message.gsub(/[ -]/,'_').upcase
      err_name = message.gsub(/[ -]/,'')
      eval %-
        RC_#{var_name} = #{code}
        class #{err_name}Error < HTTPStatusError
          def code; RC_#{var_name}; end 
        end
      -
    }

    def HTTPStatus.message(code)
      StatusMessage[code]
    end
    
    def HTTPStatus.info?(code)
      code >= 100 and code < 200
    end
    def HTTPStatus.success?(code)
      code >= 200 and code < 300
    end
    def HTTPStatus.redirect?(code)
      code >= 300 and code < 400
    end
    def HTTPStatus.error?(code)
      code >= 400 and code < 600
    end
    def HTTPStatus.server_error?(code)
      code >= 400 and code < 500
    end
    def HTTPStatus.client_error?(code)
      code >= 500 and code < 600
    end
  end
end

if __FILE__ == $0
  
#require 'HTTPStatus'

  include WEBrick

  #コード定数とデフォルトのメッセージの表示
  rc = 200
  if rc = HTTPStatus::RC_OK
    print HTTPStatus.message(rc),"\n" # => 'OK'
  end

  # 状態の確認
  if HTTPStatus.success?(rc)
    print HTTPStatus.message(rc), "\n" # => 'OK'
  end

  #コードからメッセージを生成

  print HTTPStatus.message(505),"\n"
    # => 'HTTP Version Not Supported

  print HTTPStatus::RC_NOT_FOUND,"\n" # => 404

  # HTTPStatusをincludeした場合
  include HTTPStatus
  rc = 200
  if rc = RC_OK
    print HTTPStatus.message(rc),"\n" # => 'OK'
  end
  
  # 例外からコードを参照
  err = ProxyAuthenticationRequiredError.new
  p err.code # => 407

end
