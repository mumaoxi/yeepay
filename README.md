# Yeepay

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/yeepay`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-hmac'
gem 'yeepay', github: 'mumaoxi/yeepay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yeepay

## Configuration

```ruby
Yeepay.p1_mer_id = 'YOUR_MER_ID' #商户编号
Yeepay.merchant_key = 'YOUR_MERCHANT_KEY' #商户密钥

#Yeepay.debug_mode = true # Enable parameter check. Default is true.
```


## Service

### 充值卡支付接口

#### Name

```ruby
create_trade
```

#### Definition

```ruby
Yeepay::Service::Card.create_trade({OPTIONS})
```

#### Example
```ruby
options = {
    out_trade_no: DateTime.now.strftime('%Y%m%d%H%M%S')+Random.rand(1000).to_s,
    total_fee: 150,
    verify_fee: true,
    notify_url: 'http://example.com/pays/yeepay_notify',
    cards: [
        {amt: 50,
         no: '123456',
         pwd: '654321'
        },
        {amt: 100,
         no: '123',
         pwd: '654'
        }
    ],
    frp_id: 'SZX'

}
Yeepay::Service::Card.create_trade(options)
# => '{:r0_Cmd=>"ChargeCardDirect", :r1_Code=>"1", :r6_Order=>"20150415150818837", :rq_ReturnMsg=>"提交成功!", :hmac=>"ba06a390eb8f487d84282da5fb90b862"}'
```

#### Arguments

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_trade_no | required | Order id in your application. |
| total_fee | required | Order item's price. |
| verify_fee | required | whether check price between cards and order. |
| notify_url | required | Yeepay asyn notify url. |
| frp_id    | required | Pay channel id |

This is not a complete list of arguments, please read official document: http://www.yeepay.com .


### 充值卡支付通知接口

#### Name

```ruby
verify?
```

#### Definition
```ruby
Yeepay::Service::Card.verify?({OPTIONS})
```

### Example
```ruby
options = {
        r0_Cmd: 'ChargeCardDirect',
        r1_Code: '2',
        p1_MerId: '10012367775',
        p2_Order: '20150415123733472',
        p3_Amt: '0.0',
        p4_FrpId: 'SZX',
        p5_CardNo: '123,123456',
        p6_confirmAmount: '0.0,0.0',
        p7_realAmount: '0.0,0.0',
        p8_cardStatus: '7,7',
        p9_MP: '',
        pb_BalanceAmt: '',
        pc_BalanceAct: '',
        r2_TrxId: '',
        hmac: '654b58ece9b4377eaad4c1ebb013a668'
    }
Yeepay::Service::Card.verify?(options)
# => true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/yeepay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
