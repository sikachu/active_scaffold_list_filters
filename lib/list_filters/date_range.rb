class DateRange < ActiveScaffold::DataStructures::ListFilter

	# Return a list of conditions based on the params 
	def conditions(params)
	  date_start = "#{params["start"]["year"]}-#{params["start"]["month"]}-#{params["start"]["day"]} 00:00:00"
	  date_end = "#{params["end"]["year"]}-#{params["end"]["month"]}-#{params["end"]["day"]} 23:59:59"
		return ["#{@core.model.table_name}.#{options[:field]} >= ? AND #{@core.model.table_name}.#{options[:field]} <= ?", date_start, date_end]
	end
	
end
