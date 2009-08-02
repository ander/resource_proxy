
module ResourceProxy
  
  # Same as SessionProxy, but uses "Rails.cache" for storage.

  # Also, accepts :key_prefix option e.g. if you don't want
  # different users' data to collide. :key_prefix needs to be the
  # same on subresources and their parent.
  class RailsCache < ResourceProxy::CRUD

    # return new proxy if accepted, otherwise nil
    def self.accept(klass, params, opts)
      return nil unless (params[:id] == 'cache' or params[:proxy] == 'cache')
     
      proxy = ResourceProxy::RailsCache.new(klass, opts)
      if atts = params[klass.to_s.underscore.to_sym]
        proxy.update_attributes(atts)
      end
      proxy
    end
  
    ####################################
  
    def initialize(klass, opts={})
      @klass = klass
      @belongs_to = opts[:belongs_to]
      @key_prefix = opts[:key_prefix]
    end

    private

    def proxied_class; @klass end

    def fetch_data  
      data = (Rails.cache.read(key) || {}).dup
      data.delete(:subs)
      data
    end

    def is_subresource?; !@belongs_to.nil? end

    def subresources
      data = Rails.cache.read(key)
      return nil unless data
      data[:subs]
    end

    # storing is the only thing that really works for subresources
    def store_data(atts)
      if @belongs_to
        data = (Rails.cache.read(parent_key) || {}).dup
        data[:subs] ||= {}
        data[:subs][key] ||= []
        data[:subs][key] << atts
        Rails.cache.write(parent_key, data)
      else
        data = Rails.cache.read(key) || {}
        Rails.cache.write(key, data.merge(atts))
      end
    end

    def clear_data
      Rails.cache.delete(key)
    end

    def parent_key
      return nil unless is_subresource?
      "#{@key_prefix}#{@belongs_to}"
    end
  
    def key
      if @belongs_to
        @klass.to_s.pluralize.underscore
      else
        "#{@key_prefix}#{@klass.to_s.underscore}"
      end
    end

  end

end

