# coding: utf-8
require 'roo'

##################################### Read File ###########################################

path = '../../zhendi-data/products'

all_xls_files = Dir[ path + "/**/*.xlsx"]

all_jpg_files = Dir[ path + "/**/*.jpg"]

##################################### Init Data ###########################################

category = ['property', '']
shipping_category = Spree::ShippingCategory.find_or_create_by!(name: "快递")

###########################################################################################

#all_xls_files = ['../../zhendi-data/products/冲调饮品/洋酒/红酒/费尔南多.xlsx']

remove_files = [
  "施多客乐飞飞榛子太妃巧克力",
  "施多客蜜思榛子太妃巧克力",
  "瑞士莲香橙慕斯巧克力",
  "瑞士莲樱桃辣椒慕斯巧克力",
  "瑞士三角蜂蜜奶油杏仁牛奶巧克力",
  "瑞士莲蔓越莓慕斯巧克力",
  "瑞士三角蜂蜜奶油杏仁黑巧克力",
  "瑞士莲薰衣草蓝莓慕斯巧克力",
  "施格特草莓酸奶夹心巧克力",
  "施格特阿尔卑斯牛奶巧克力",
  "施格特榛子酱夹心巧克力",
  "施格特杏仁浆夹心巧克力",
  "施格特阿尔卑斯牛奶榛子夹心巧克力",
  "施格特曲奇碎黑白夹心夹心巧克力",
  "施格特杏仁夹心巧克力",
  "秒卡白巧克力",
  "黑山奶味三角巧克力",
  "三色果干",
  "蔓越莓干",
  "葡萄干",
  "西梅干",
  "加州西梅",
  "红酒樱桃果",
  "榴的华水仙芒果干",
  "榴的华香蕉干",
  "维米最爱苹果玫瑰果果汁",
  "维米最爱多种水果果汁",
  "维米最爱小草莓果汁",
  "维米最爱石榴果汁",
  "维米最爱黄杏果汁",
  "维米最爱草莓果汁",
  "维米最爱菠萝果汁",
  "维米最爱番茄汁饮料",
  "维米最爱葡萄果汁",
  "维米最爱樱桃汁",
  "酷卡未加味天然苏打水",
  "溢彩菠萝味芦荟饮料",
  "美乐津苹果味果汁软糖",
  "美乐津草莓味果汁软糖",
  "美乐津水蜜桃味果汁软糖",
  "经典100%多种水果果汁"
]


all_xls_files[0..-1].each_with_index do |file_path, index|
  #all_xls_files.each_with_index do |file_path, index|
  remove = false
  remove_files.each do |remove_file_name|
    remove = true if (file_path.include? remove_file_name + ".xlsx")
  end
  next if remove

  p "file_path index #{index} #{file_path}---------------------------------"
  product = nil
  begin
    sheet = Roo::Spreadsheet.open(file_path, extension: :xlsx).sheet(0)
  rescue Zip::Error #fix open xlsx via xls
    #sheet = Roo::Spreadsheet.open(file_path)
  end
  #read from one file

  #####Step1: Get Category first

  category = "属性"
  (1..sheet.count).each do |row_index|
    row = sheet.row(row_index)
    first_column_name = row[0]
    second_column_name = row[1]

    if first_column_name == nil
      (1..sheet.count).each do |next_row_index|
        row = sheet.row(row_index + next_row_index)
        if not row.compact.empty?
          category = row[0]
          break
        end
      end

    else
      first_column_name.strip!
      if(first_column_name.last == "：" or first_column_name.last == ":")
        first_column_name = first_column_name[0..-2]
      end
    end

    p category
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
        product.available_on = Time.now;
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
    elsif category == "营养成分表" or category == "矿物质含量（毫克/升）" or category == "项目"
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
      next if second_column_name == nil && row[2] == nil
      second_column_name ? skip_second = false : skip_second = true
      property_count = product.option_types.count
      option_values =(1..property_count).map do |property_index|
        name = row[property_index-1]
        name = row[property_index] unless name
        name = name.gsub('批发50', '批发51') if(name.include? '批发50')
        name = name.gsub('批发10', '批发11') if(name.include? '批发10')
        name = name.gsub('200', '500') if(name.include? '-200')
        Spree::OptionValue.find_by(name: name)
      end

      variant = product.variants.new(option_values: option_values)
      skip_second ? variant.price = row[property_count + 1] : variant.price = row[property_count]
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
    unless product.save
      p category
      p first_column_name
      p product.errors.full_messages
      raise
    end
    p "file_path index #{index} #{file_path}---------------------------------"
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

  product.sales_amount = rand(300)
  product.save

  sheet.close()

  p product.name

end

Spree::StockItem.all.each do |item|
  item.count_on_hand = 1000;
  item.backorderable = true;
  item.save;
end
