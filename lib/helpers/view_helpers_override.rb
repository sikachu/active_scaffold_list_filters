module ActiveScaffold
  module Helpers
    module ViewHelpers
      # Add the list filter plugin includes
      def active_scaffold_includes_with_list_filter(frontend = :default)
        css = stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path('list_filter-stylesheet.css', frontend))
        ie_css = stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path("list_filter-stylesheet-ie.css", frontend))
        active_scaffold_includes_without_list_filter + "\n" + css + "\n<!--[if IE]>" + ie_css + "<![endif]-->\n"
      end
      alias_method_chain :active_scaffold_includes, :list_filter
      
      def list_filter_date_select(date, start_or_stop, filter)
        if defined?(CalendarDateSelect)
          calendar_date_select_tag "#{list_filter_input_name(filter)}[text_#{start_or_stop}]", date,
            :after_close => "$('#{list_filter_form_id}').onsubmit()"
        else
          select_date date, :prefix => "#{list_filter_input_name(filter)}[#{start_or_stop}]"
        end
      end
    end
  end
end
