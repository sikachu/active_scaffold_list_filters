class AssociationValues < ActiveScaffold::DataStructures::ListFilter
  def conditions(params)
    add_through_option_to_includes if options[:through]
    return ["`#{options[:table_name]}`.`#{options[:field]}` IN (?)", params]
  end
  
  def add_through_option_to_includes
    if !@core.columns[options[:through]].includes.include?(options[:table_name])
      @core.columns[options[:through]].includes << options[:table_name] 
    end
  end
end