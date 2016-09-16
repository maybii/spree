# coding: utf-8
#rake db:drop:all
#rake db:create:all
#rake db:migrate

Spree::Product.destroy_all
Spree::Order.destroy_all
Spree::Wishlist.destroy_all
Spree::Address.destroy_all
Spree::Property.destroy_all
Spree::OptionType.destroy_all
Spree::ShippingCategory.destroy_all
Spree::Taxonomy.destroy_all
Spree::Taxon.destroy_all
Spree::Variant.destroy_all
Spree::OptionType.destroy_all
Spree::OptionValueVariant.destroy_all
Spree::Variant.destroy_all
Spree::StockItem.destroy_all
Spree::LineItem.destroy_all
Spree::Zone.destroy_all
Spree::ShippingMethod.destroy_all
Spree::Calculator.destroy_all

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

shipping_category = Spree::ShippingCategory.find_or_create_by!(name: "快递")
shipping_method = Spree::ShippingMethod.find_or_create_by(name: '快递')
shipping_method.shipping_categories.push shipping_category

shipping_rate = Spree::Calculator::Shipping::FlatRate
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
