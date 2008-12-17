class Values < ActiveScaffold::DataStructures::ListFilter

	# Return a list of conditions based on the params 
	def conditions(params)
		return ["#{@core.model.table_name}.#{options[:field]} IN (?)", params]
	end
	
end
