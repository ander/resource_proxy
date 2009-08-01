# Include hook code here

ResourceProxy.register(:ar, ActiveRecordProxy)
ResourceProxy.register(:cache, RailsCacheProxy)
ResourceProxy.register(:session, SessionProxy)

ActiveRecord::Base.send(:extend, ResourceProxy::Finder)
