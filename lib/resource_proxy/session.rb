
module ResourceProxy

  
  # Session based resource proxy.
  #
  # Requires option :store to be passed in find_proxy call. E.g.
  # @car = Car.find_proxy(params, [:session, :ar], {:store => session})
  #
  # Subresources can be defined this way:
  # @tire = Car.find_proxy(params, [:session, :ar], {:store => session, 
  #                                                  :belongs_to => :car})  
  class Session < ResourceProxy::CRUD

    def self.accept(klass, params, opts)
      return nil unless (params[:id] == 'session' or params[:proxy] == 'session')

      proxy = ResourceProxy::Session.new(klass, opts)
      if atts = params[klass.to_s.underscore.to_sym]
        proxy.update_attributes(atts)
      end
      proxy
    end
  
    ####################################
  
    def initialize(klass, opts)
      @klass = klass
      @store = opts[:store]
      @belongs_to = opts[:belongs_to]
    
      raise "No :store option for SessionProxy!" unless @store
    end

    private

    def proxied_class; @klass end
  
    def fetch_data  
      data = (@store[key] || {}).dup
      data.delete(:subs)
      data
    end

    def is_subresource?; !@belongs_to.nil? end

    def subresources
      return nil unless @store[key]
      @store[key][:subs]
    end

    # storing is the only thing that really works for subresources
    def store_data(atts)
      if @belongs_to
        parent = @belongs_to.to_s
        @store[parent] ||= {}
      
        @store[parent][:subs] ||= {}
        @store[parent][:subs][key] ||= []
        @store[parent][:subs][key] << atts
      else
        @store[key] ||= {}
        @store[key].merge!(atts)
      end
    end

    def clear_data
      @store[key] = {}
    end
  
    def key
      if @belongs_to
        @klass.to_s.pluralize.underscore
      else
        @klass.to_s.underscore
      end
    end

  end

end

