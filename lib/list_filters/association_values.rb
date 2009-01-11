class AssociationValues < ActiveScaffold::DataStructures::ListFilter
  def conditions(params)
    return ["#{options[:table_name]}.#{options[:field]} IN (?)", params]
  end
end