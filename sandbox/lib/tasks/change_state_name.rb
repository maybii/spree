# coding: utf-8
Spree::Zone.destroy_all

china = Spree::Country.find_by("name": "China")
Spree::Config[:default_country_id] = china.id

# delete unused id
Spree::Country.all.each do |country|
  next if spree.id == china.id
  spree.destroy
end
chinese_name = ["北京", "天津", "河北", "山西", "内蒙古", "辽宁", "吉林", "黑龙江", "上海", "江苏", "浙江", "安徽", "附件", "江西", "山东", "河南", "湖北", "湖南", "广东", "广西", "海南", "重庆", "四川", "贵州", "云南", "西藏", "陕西", "甘肃", "青海", "宁夏", "新疆", "台湾", "香港", "澳门"]

english_name = ["Beijing", "Tianjin", "Hebei", "Shanxi", "Nei Mongol", "Liaoning", "Jilin", "Heilongjiang", "Shanghai", "Jiangsu", "Zhejiang", "Anhui", "Fujian", "Jiangxi", "Shandong", "Henan", "Hubei", "Hunan", "Guangdong", "Guangxi", "Hainan", "Chongqing", "Sichuan", "Guizhou", "Yunnan", "Xizang", "Shaanxi", "Gansu", "Qinghai", "Ningxia", "Xinjiang", "Taiwan", "Xianggang (Hong-Kong)", "Aomen (Macau)"]

if chinese_name.count != english_name.count
  raise "english count != chinese count"
end

english_name.each_with_index do |state_name, index|
  state = Spree::State.find_by("name": state_name)
  state.name = chinese_name[index]
  state.save()
end
