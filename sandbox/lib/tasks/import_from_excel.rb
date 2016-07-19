# coding: utf-8
require 'roo'

##################################### Read File ###########################################

path = '/local/code/zhendi/data/products/'

all_files = Dir.entries(path)

all_xls_files = all_files.select{ |f| f.include?('xlsx') and f.first != '.'}

##################################### Init Data ###########################################

category = ['property', '']
shipping_category = Spree::ShippingCategory.find_or_create_by!(name: "快递")
available_on = Time.now

###########################################################################################

all_xls_files.each do |file_name|
  product = nil

  sheet = Roo::Spreadsheet.open(path + file_name).sheet(0)
  #read from one file

  #####Step1: Get Category first

  category = "属性"
  (1..sheet.count).each do |row_index|
    row = sheet.row(row_index)
    first_column_name = row[0]
    second_column_name = row[1]

    if first_column_name == nil
      category = sheet.row(row_index + 1)[0] rescue next
    else
      first_column_name.strip!
      if(first_column_name.last == "：" or first_column_name.last == ":")
        first_column_name = first_column_name[0..-2]
      end
    end

    ############################################################################################
    if category == "属性"
      second_column_name ||= "见包装瓶盖所示"

      if first_column_name == "品名"
        ## new a product
        slug = PinYin.permlink(second_column_name)
        product = Spree::Product.find_or_initialize_by(slug: slug)
        product.name = second_column_name
        product.price = 0
        product.shipping_category = shipping_category
        product.available_on = available_on;
        product.description = nil;
      elsif first_column_name == "条形码"
        product.sku = second_column_name.to_s
      elsif first_column_name == "类别"
        taxon = nil
        taxons = second_column_name.split('/')
        current_taxon = nil
        taxons.each do |c|
          current_taxon = Spree::Taxon.find_by(parent: current_taxon, name: c)
        end
        product.taxons.push current_taxon unless product.taxons.include? current_taxon
      else
        first_column_name = "产品品牌" if(first_column_name.include? "品牌")
        first_column_name = "保质期" if(first_column_name.include? "保质期")
        first_column_name = "生产商" if(first_column_name.include? "生产商")
        product.set_property(first_column_name, second_column_name)
      end
    ###########################################################################################
    elsif category == "营养成分表"
      if product.description == nil or product.description.empty?
        product.description = "<table class='nutrient'></table>"
      else
        line = "<tr>" +
               "<td class='title'>#{row[0]}</td>" +
               "<td class='value1'>#{row[1]}</td>" +
               "<td class='value2'>#{row[2]}</td>" +
               "</tr>"
        product.description = product.description.insert(-9, line)
      end

    #########################################################################################
    elsif category == "价格规格"

    end

    unless product.save
      p category
      p first_column_name
      p product.errors.full_messages
      raise
    end

  end
end
