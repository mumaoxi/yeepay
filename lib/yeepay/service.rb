module Yeepay
  module Service
    GATEWAY_URL = 'https://www.yeepay.com/app-merchant-proxy/command.action'

    #参数签名
    def self.hmac_md5_sign(options={})
      warn("options #{options}")
      HMAC::MD5.hexdigest(Yeepay.merchant_key, options.values.join(''))
    end

    module Card

      #提交支付返回的错误代码
      SUBMIT_ERROR_CODES = {
          -100 => '卡面额与订单金额不符',
          -1 => '签名较验失败或未知错误',
          1 => '提交成功!',
          2 => '卡密成功处理过或者提交卡号过于频繁',
          5 => '卡数量过多，目前最多支持10张卡',
          7 => '支付卡密无效！',
          11 => '订单号重复',
          66 => '支付金额有误',
          95 => '支付方式未开通',
          112 => '业务状态不可用，未开通此类卡业务',
          8001 => '卡面额组填写错误',
          8002 => '卡号密码为空或者数量不相等'
      }

      #校验卡的支付金额
      def self.card_fee_ok?(options={})
        if options[:verify_fee]
          card_total_fee = options[:cards].collect { |card| card[:amt] }.inject(:+)
          warn("\ncard_total_fee:#{card_total_fee},order_total_fee:#{options[:total_fee]}")
          unless options[:total_fee] == card_total_fee
            return false
          end
        end
        true
      end

      #组合发起支付请求的必要参数
      def self.gen_params(options={})
        {
            :p0_Cmd => 'ChargeCardDirect',
            :p1_MerId => Yeepay.p1_mer_id,
            :p2_Order => options[:out_trade_no],
            :p3_Amt => options[:total_fee],
            :p4_verifyAmt => options[:verify_fee],
            :p8_Url => options[:notify_url],
            :pa7_cardAmt => options[:cards].collect { |card| card[:amt] }.join(','),
            :pa8_cardNo => options[:cards].collect { |card| card[:no] }.join(','),
            :pa9_cardPwd => options[:cards].collect { |card| card[:pwd] }.join(','),
            :pd_FrpId => options[:frp_id],
            :pr_NeedResponse => '1',
        }
      end

      #获取返回的需要验证的参数
      def self.res_verifying_params(options={})
        keys = [:r0_Cmd,
                :r1_Code,
                :p1_MerId,
                :p2_Order,
                :p3_Amt,
                :p4_FrpId,
                :p5_CardNo,
                :p6_confirmAmount,
                :p7_realAmount,
                :p8_cardStatus,
                :p9_MP,
                :pb_BalanceAmt,
                :pc_BalanceAct,
                :r2_TrxId]
        options.select { |key, value|
          keys.include?(key)
        }
      end

      #处理支付请求结果
      def self.receive_response(options,res)
        res_data = {}
        res.to_s.split(/\n/).map { |item|
          key_value = item.to_s.split(/=/)
          res_data[key_value[0].to_s.to_sym] = key_value[1]
        }
        unless card_fee_ok?(options)
          res_data[:r1_Code] = -100
        end
        res_data[:rq_ReturnMsg] = SUBMIT_ERROR_CODES[res_data[:r1_Code].to_s.to_i]
        res_data
      end
    end
  end
end