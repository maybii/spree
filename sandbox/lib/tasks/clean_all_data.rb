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
Spree::PaymentMethod.destroy_all
