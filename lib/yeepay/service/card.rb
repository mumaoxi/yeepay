module Yeepay
  module Service
    module Card
      #发起支付交易
      def self.create_trade(options = {})
        #组合支付请求参数
        trade_data = gen_params(options)
        trade_data[:hmac] = Yeepay::Service.hmac_md5_sign(trade_data)
        warn("\ntrade_data #{trade_data}")

        #发起支付请求
        begin
          res = open("#{GATEWAY_URL}?#{trade_data.collect { |key, value| "#{key}=#{value}" }.join('&')}").read
          warn("\nres #{res}")
        rescue => err
          warn("\nSocketError #{err}\n\n")
          return {}
        end

        #处理支付结果
        res_data = receive_response(res)
        warn("\nres_data #{res_data}")
        res_data
      end

      #校验支付签名
      def self.verify?(options={})
        notify_params = res_verifying_params(options)
        warn("\nnotfy_params  #{notify_params}")
        notify_hmac = Yeepay::Service.hmac_md5_sign(notify_params)

        warn("\nnotify_sign #{options[:hmac]}, verify_sign: #{notify_hmac}")
        notify_hmac == options[:hmac]
      end
    end
  end
end
