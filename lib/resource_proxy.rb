=begin rdoc

ResourceProxy

=end
module ResourceProxy
  mattr_reader :all
  
  def self.register(sym, klass)
    @@all ||= {}
    @@all[sym] = klass
  end
  

  module Finder

    # E.g. Car.find_proxy(params, [:session, :ar], {:store => session})
    # will try to find first via SessionProxy, then via ActiveRecordProxy
    # passing :store option for former and no options for latter.
    def find_proxy(params, proxy_types, *opts)
      proxy_types.each_with_index do |p_type, i|
        proxy = ResourceProxy.all[p_type].try(:accept, self, params, 
                                              (opts[i] || {}))
        return proxy if proxy
      end
      
      raise "No proxy found for class #{self} with params #{params.inspect}"
    end
  end
end
