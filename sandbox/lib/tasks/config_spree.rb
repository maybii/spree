# coding: utf-8
Spree::Config.currency = "CNY"

zone = Spree::Zone.find_or_create_by(
  {
    name: "中国", description: "中国", default_tax: false,
    kind: "country"
  }
)
zone.save
z = Spree::ZoneMember.new
z.zoneable =Spree::Country.find_by(iso_name: "CHINA")
z.zone = zone
z.save

Spree::Config.address_requires_state = true
Spree::AddressBook::Config[:disable_bill_address] = true
Spree::Config[:allow_guest_checkout] = false

shipping_category = Spree::ShippingCategory.find_or_create_by!(name: "快递")
shipping_method = Spree::ShippingMethod.find_or_create_by(name: '快递')
shipping_method.shipping_categories.destroy_all
shipping_method.shipping_categories.push shipping_category

shipping_rate = Spree::Calculator::Shipping::FlatRate.new
shipping_rate.preferences[:amount] = 5
shipping_rate.calculable = shipping_method
shipping_rate.save

shipping_method.calculator = shipping_rate
shipping_method.zones.push(zone)
shipping_method.save

store = Spree::Store.first
store.name = "塞外宝岛"
store.default_currency = "CNY"
store.save

alipay = Spree::Gateway::AlipayDirect.find_or_initialize_by(name: '支付宝')
alipay.preferences[:alipay_pid] = '2088022452414794'
alipay.preferences[:alipay_key] = '2bk2c3k1edwtfko1e7wfu677zoouafzc'
alipay.active = true
alipay.save

check = Spree::PaymentMethod::Check.find_or_initialize_by(name: '账户转账')
check.active = true
check.description = "<p>开户行：中国农业银行 内蒙古二连浩特市友谊支行</p><p>农业银行卡号： 62284 5505 60101 94762  户名：明干巴雅尔</p>"
check.save

['商品需要维修', '收到的商品破损', '商品错发/漏发', '物品和描述不一致', '物品缺少部件', '商品质量问题', '其他'].each do |name|
  Spree::ReturnAuthorizationReason.create(name: name)
end
