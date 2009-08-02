module ResourceProxy
  
  # ActiveRecord resource proxy.
  class ActiveRecord

    def self.accept(klass, params, opts)
      if params[:id]
        klass.find(params[:id], opts)
      else
        klass.new(params[klass.to_s.underscore.to_sym] || {})
      end
    end
  end

end

