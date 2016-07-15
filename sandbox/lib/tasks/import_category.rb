require 'roo'

path = '/local/code/zhendi/data/others/category.xlsx'

xlsx = Roo::Excelx.new(path)

parent = nil
sub_parent = nil

taxonomy = nil

xlsx.each_row_streaming do |row|
  row.each_with_index do |cell, index|
    value = cell.value
    if index == 0 && value != nil
      taxonomy = Spree::Taxonomy.find_or_create_by(name: value)
      parent = taxonomy.taxons.first
    end
    if index == 1 && value != nil
      sub_parent = taxonomy.taxons.find_or_create_by(name: value, parent: parent)
    end
    if index == 2 && value != nil
      taxonomy.taxons.find_or_create_by(name: value, parent: sub_parent)
    end
  end
  # puts row.inspect # Array of Excelx::Cell objects
end
