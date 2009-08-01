# Include hook code here

ResourceProxy.register(:ar, ActiveRecordProxy)
ResourceProxy.register(:session, SessionProxy)

ActiveRecord::Base.send(:extend, ResourceProxy::Finder)
