ActiveScaffoldListFilters
=========================
 Copyright (c) 2008 Tys von Gaza (tys@gotoybox.com)
 
 MIT License use as you wish, see MIT-LICENSE file
 
 Version 0.31

[Preview](http://activescaffoldlistfilters.googlecode.com/files/Picture%201.png)

Add a filter menu at the top of the ActiveScaffold List view.  The filter can be whatever you dream up.  Code inspiration: activescaffoldexport plugin.

Todo/Know Bugs (Please Help!)
-----------------------------

* If you have activescaffoldexport installed, please see this kb issue: [http://code.google.com/p/activescaffoldexport/issues/detail?id=4](http://code.google.com/p/activescaffoldexport/issues/detail?id=4)
* Have the reset link not close the filter, but actually reset it.
* Ability to save filters (and table orderings!) to the database, this will be a separate plugin.
* Association filter may not work with has_and_belongs_to_many associations.
* Tests need to be created!  I don't have much experience here, help or advice welcome.
* Ability to get a count of rows in the _current_ list for each association in the association filter.  Ie color the options different if there is results or not.  Tricky, need to update the filter along with the list.  Thoughts?
* Doesn't javascript degrade... not an issue in our project so won't fix.

Ideas for filters
-----------------

* Map, 100km's from point (http://en.wikipedia.org/wiki/Haversine_formula)
* iTunes style browser (update categories as you filter)

Current implemented filters
---------------------------

* **:association**
  
  Filter record based on associations
  
        config.list_filter.add(:association, :district, {:label => "District", :association => [ :unit, :district ] })
  
* **:values**

  Filter record based on set of values array or hash, i.e. record's status field
  
        config.list\_filter.add(:values, :status, {:label => "User status", :field => :status, :values => [["Activated", "activated"], ["Not activated", "not\_activated"]] })
  
  Also, :values filter supports values on associations. This is handy if you are displaying association data
  and want to filter that, too. Ex. to filter a blog posts' comments count while viewing
  a list of posts, you might need to do something like:
  
        (in PostController)
        
        config.list\_filter.add(:values, :verified, {
            :label => "Verified Comments",
            :field => :verified,
            :table_name => :comments,
            :values => [["Verified", "verified"]]
        })
        
  This would essentially be checking that the comment count for posts was only for verified comments.

  Additionally, to make things really crazy (read: slow), it also takes a :through parameter. In the example above, if
  for some reason your comments were only related to posts through users, you could do:
  
        config.list\_filter.add(:values, :verified, {
            :label => "Verified Comments",
            :field => :verified,
            :table_name => :comments,
            :through => :users,
            :values => [["Verified", "verified"]]
        })
  
  The PostsController filter would then make an include to grab the values through the users table.
  Again, this will be slow.

* **:date\_range**

  Filter record in between two date ranges
  
        config.list\_filter.add(:date\_range, :create_at, {:label => "User registration", :field => :created\_at })


Installing
----------

1.  Install this plugin using script/plugin install (for Rails > 2.1.0)

        script/plugin install git://github.com/sikachu/active\_scaffold\_list\_filters.git

    or just clone to your vendor/plugins

        git clone git://github.com/sikachu/active\_scaffold\_list\_filters.git vendor/plugins/active\_scaffold\_list\_filter

2.  Add to your application.rb default action list or to an individual controller:

    app/controllers/application.rb

        class ApplicationController < ActionController::Base
          ActiveScaffold.set_defaults do |config|
            config.actions.add :list_filter
          end
        end

    or an individual controller

        active_scaffold "Model" do |config|
          config.actions.add :list_filter
        end

3.  Add a filter
    
    The form is:
    *   `config.list_filter.add(:filter_type, :filter_name, {:label => "Filter Label", :other => "options"})`
    *   `:filter_type` is the type of filter
    *   `:filter_name` is the name you want to use for the filter, should be unique in your scaffold
    *   `{}` is the options hash, `:label` is on the base filters, but you can set whatever you like to be used by your filter  
    
    ie: Add an Association (checkboxes) filter, named district, with the label Districts and method chain of model.unit.district:
    
        active_scaffold "Model" do |config|
          config.list_filter.add(:association, :district, {:label => "District", :association => [ :unit, :district ] })
        end

----

Creating your own filters
-------------------------

It is simple to create your own filter.

1. Choose a name to use, ie "association".
2. Create a new view in `active_scaffold_list_filters/frontends/default/views/`, ie: `active_scaffold_list_filters/default/views/_association.rhtml`

3. Use this to create a way for your user to interact with your filter.  You have access to a `ListFilter` object (see `lib/data_structures/list_filter.rb`), which you'll later extend with your own methods.  This object allows you get your filters `type`, `name`, and `options` set in the controller.

   Your filter view must set form fields. Use the `list_filter_input_name(filter)` to get a base name to use. If you're setting more then one field then use form array's, ie: `list_filter_input_name(filter)['field2']`, or if you're using checkboxes or multi select menu's you can use an array like so: `list_filter_input_name(filter)[]`
   
4. Create a new List Filter in `active_scaffold_list_filters/list_filters`, ie: `active_scaffold_list_filters/list_filters/association.rb`
   
   This file must have the following layout:

        class Association < ActiveScaffold::DataStructures::ListFilter
          # Return a list of conditions based on the params 
          def conditions(params)
        	  association = association_tree[association_tree.size - 1]
        	  column = [association.active_record.table_name, association.primary_key_name].join('.')
        	  return ["#{column} IN (?)", params]
          end
        end

    You must then define the method `conditions(params)` to return a list of filter conditions. These will be used to filter your table's data.
    
    You have access to your the `ListFilter` that you're extending again with the same properties as above. You also have a list of parameters from your view.
    
    This file can also contain custom methods used in your view or conditions, sky is the limit!
    
5. Upload your filter object and view for others to use and improve!