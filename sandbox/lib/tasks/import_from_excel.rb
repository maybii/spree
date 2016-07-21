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
        if first_column_name == "净含量"
          product.weight = second_column_name.match(/\d+/)[0].to_i rescue 0
        end
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
      product.variants.destroy_all if first_column_name == "价格规格"
      next unless second_column_name
      print("jiage #{first_column_name}  #{second_column_name}")
      property_count = product.option_types.count
      option_values =(1..property_count).map do |property_index|
        Spree::OptionValue.find_by(name: row[property_index-1])
      end
      variant = product.variants.new(option_values: option_values)
      variant.price = row[property_count]
      variant.save
    else
      # property
      next if first_column_name == nil
      if second_column_name != nil
        option_type = Spree::OptionType.find_or_create_by(name: first_column_name, presentation: first_column_name)
        for option_value in row.compact[1..-1]
          option_type.option_values.find_or_create_by(name: option_value, presentation: option_value)
        end
        option_type.save()

        product.option_types.push(option_type) unless (product.option_type_ids.include? option_type.id)
      end
    end

    unless product.save
      p category
      p first_column_name
      p product.errors.full_messages
      raise
    end
  end

  ######################################### Add Image ############################################
  product.images.destroy_all
  product.images.create(attachment: File.open("/home/zheng/Pictures/iloveu.png"))

end
