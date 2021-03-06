
module ResourceProxy
  
  # A CRUD resource proxy to be used as a superclass.
  class CRUD

    # return new proxy if accepted, otherwise nil
    def self.accept(klass, params, opts)
      raise "implement .accept"
    end
  
    ####################################
  
    def update_attributes(atts)
      store_data(atts)
    end
  
    alias_method :update_attributes!, :update_attributes
    alias_method :attributes=, :update_attributes
  
    def save
      return self if is_subresource?

      resource = build_resource
      result = resource.save
      clear_data if result
      result
    end
  
    def save!
      return self if is_subresource?

      resource = build_resource
      result = resource.save!
      clear_data
      result
    end
  
    def destroy
      clear_data
    end
  
    def method_missing(meth, *args)
      build_resource.send(meth, *args)
    end

    private
  
    def proxied_class
      raise "implement #proxied_class"
    end
  
    def fetch_data  
      raise "implement #fetch_data"
    end

    def store_data(atts)
      raise "implement #store_data"
    end

    def clear_data
      raise "implement #clear_data"
    end

    def is_subresource?
      raise "implement #is_subresource?"
    end

    # subresources should return a hash of sub resource attributes, e.g.
    # {:tires            => [{:brand => 'foo'}, {:brand => 'bar'}],
    #  :some_other_assoc => [{...}] }
    # or nil
    def subresources
      raise "implement #subresources"
    end

    def build_resource
      data = fetch_data
      subs = subresources
      resource = proxied_class.new(data)
    
      return resource unless subs
    
      subs.each do |assoc, attributes_arr|
        attributes_arr.each do |atts|
          resource.send(assoc).build(atts)
        end
      end
      resource
    end

  end

end
