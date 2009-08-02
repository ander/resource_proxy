# Include hook code here

ResourceProxy.register(:ar, ResourceProxy::ActiveRecord)
ResourceProxy.register(:cache, ResourceProxy::RailsCache)
ResourceProxy.register(:session, ResourceProxy::Session)

ActiveRecord::Base.send(:extend, ResourceProxy::Finder)
