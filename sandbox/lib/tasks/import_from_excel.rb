# coding: utf-8
require 'roo'

##################################### Read File ###########################################

path = '../../zhendi-data/products'

all_xls_files = Dir[ path + "/**/*.xlsx"]

all_jpg_files = Dir[ path + "/**/*.jpg"]

##################################### Init Data ###########################################

category = ['property', '']
shipping_category = Spree::ShippingCategory.find_or_create_by!(name: "快递")
available_on = Time.now

###########################################################################################

all_xls_files.each do |file_path|
  product = nil

  sheet = Roo::Spreadsheet.open(file_path).sheet(0)
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
        next if Spree::Variant.find_by(sku: second_column_name.to_s)
        product.sku = second_column_name.to_s
      elsif first_column_name == "类别"
        taxon = nil
        taxons = second_column_name.split('/')
        if taxons.last == '矿物质水' and taxons[-2] == "纯净"
          taxons = taxons[0..-3].push("纯净/矿物质水")
        end
        current_taxon = nil
        taxons.each do |c|
          c = "茶叶" if c == "茶"
          current_taxon = Spree::Taxon.find_or_create_by(parent: current_taxon, name: c)
        end
        product.taxons.push current_taxon unless product.taxons.include? current_taxon
        else
        if first_column_name == "净含量"
          product.weight = second_column_name.match(/\d+/)[0].to_i rescue 0
        end
        first_column_name = "产品品牌" if(first_column_name.include? "品牌")
        first_column_name = "保质期" if(first_column_name.include? "保质期")
        first_column_name = "生产商" if(first_column_name.include? "生产商")
        product.set_property(first_column_name, second_column_name)
      end
    ###########################################################################################
    elsif category == "营养成分表" or category == "矿物质含量（毫克/升）"
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
      product.variants.destroy_all if first_column_name == "价格规格"
      next unless second_column_name
      property_count = product.option_types.count
      option_values =(1..property_count).map do |property_index|
        name = row[property_index-1]
        name = name.gsub('批发50', '批发51') if(name.include? '批发50')
        name = name.gsub('批发10', '批发11') if(name.include? '批发10')
        name = name.gsub('200', '500') if(name.include? '-200')
        Spree::OptionValue.find_by(name: name)
      end
      variant = product.variants.new(option_values: option_values)
      variant.price = row[property_count]
      variant.save
      product.price = variant.price
    else
      # property
      next if first_column_name == nil
      next if first_column_name.include? "口味"
      first_column_name.strip!
      if second_column_name != nil
        option_type = Spree::OptionType.find_or_create_by(name: first_column_name, presentation: first_column_name)
        for option_value in row.compact[1..-1]
          option_value.gsub!('批发50', '批发51') if(option_value.include? '批发50')
          option_value.gsub!('批发10', '批发11') if(option_value.include? '批发10')
          option_value.gsub!('200', '500') if(option_value.include? '-200')
          option_type.option_values.find_or_create_by(name: option_value, presentation: option_value)
        end
        option_type.save()

        product.option_types.push(option_type) unless (product.option_type_ids.include? option_type.id)
      end
    end

    p product.name
    p file_path
    p product.id
    unless product.save
      p category
      p first_column_name
      p product.errors.full_messages
      raise
    end
  end

  ######################################### Add Image ############################################
  product.images.destroy_all
  file_name = file_path[file_path.rindex('/')+1..file_path.rindex('.')-1]
  file_name_back = file_name.gsub(' ', '-')
  file_name = file_name[0..-2] if file_name.last.to_i != 0

  all_jpg_files.each do |image_path|
    image_name = image_path[(image_path.rindex('/') + 1 )..-5]
    image_name = image_name[0..-2] if(image_name[-1].to_i != 0)
    if image_name == file_name or image_name == file_name_back
      product.images.create(attachment: File.open(image_path))
    end
  end

  raise "no pic found for #{file_name}" if product.images.empty?
end

Spree::StockItem.all.each{|item| item.count_on_hand = 1000; item.save;}
