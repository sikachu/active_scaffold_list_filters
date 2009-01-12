class Values < ActiveScaffold::DataStructures::ListFilter
  def conditions(params)
    add_through_option_to_includes if options[:through]
    table_name = options[:table_name] || @core.model.table_name
    booleanize_values(params)
    return ["`#{table_name}`.`#{options[:field]}` IN (?)", params]
  end
  
  def add_through_option_to_includes
    if !@core.columns[options[:through]].includes.include?(options[:table_name])
      @core.columns[options[:through]].includes << options[:table_name] 
    end
  end
  
  def booleanize_values(array)
    array << true if array.delete("true")
    array << false if array.delete("false")
  end
end