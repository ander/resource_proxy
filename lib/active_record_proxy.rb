=begin rdoc

ActiveRecord resource proxy. 

=end

class ActiveRecordProxy

  def self.accept(klass, params, opts)
    if params[:id]
      klass.find(params[:id], opts)
    else
      klass.new(params[klass.to_s.underscore.to_sym] || {})
    end
  end
  
end

