=begin rdoc

ActiveRecord resource proxy. 

=end

class ActiveRecordProxy

  def self.accept(klass, params, opts)
    klass.find(params[:id], opts)
  end
  
end

