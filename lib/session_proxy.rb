=begin rdoc

Session based resource proxy.

Requires option :store to be passed in find_proxy call. E.g.
@car = Car.find_proxy(params, [:session, :ar], {:store => session})

TODO :include option for subresources

=end

class SessionProxy

  # return new proxy if accepted, otherwise nil
  def self.accept(klass, params, opts)
    return nil unless (params[:id] == 'session' or params[:proxy] == 'session')
    SessionProxy.new(klass, opts)
  end
  
  ####################################
  
  def initialize(klass, opts)
    @klass = klass
    @store = opts[:store]
    raise "No :store option for SessionProxy!" unless @store
  end

  def update_attributes(atts)
    @store[key] ||= {}
    @store[key].merge!(atts)
  end
  
  alias_method :update_attributes!, :update_attributes

  def save
    resource = @klass.new(@store[key])
    result = resource.save
    @store[key] = {} if result
    result
  end
  
  def save!
    resource = @klass.new(@store[key])
    resource.save!
    @store[key] = {}
  end
  
  def destroy
    @store[key] = {}
  end
  
  def method_missing(meth, *args)
    @klass.new(@store[key] || {}).send(meth, *args)
  end

  private
  
  def key
    @klass.to_s.underscore
  end
  
end

