require 'ruby-debug'
class DateRange < ActiveScaffold::DataStructures::ListFilter

  # Return a list of conditions based on the params 
  def conditions(params)
    if params[:text_start]
      date_start = params[:text_start].to_date + " 00:00:00"
    else
      date_start = "#{params["start"]["year"]}-#{params["start"]["month"]}-#{params["start"]["day"]} 00:00:00"
    end
    
    if params[:text_end]
      date_end = params[:text_end].to_date + " 23:59:59"
    else
      date_end = "#{params["end"]["year"]}-#{params["end"]["month"]}-#{params["end"]["day"]} 23:59:59"
    end
    
    return ["#{@core.model.table_name}.#{options[:field]} >= ? AND #{@core.model.table_name}.#{options[:field]} <= ?", date_start, date_end]
  end
  
end
