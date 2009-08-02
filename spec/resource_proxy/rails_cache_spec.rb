require File.expand_path(File.dirname(__FILE__)+'/../../../../../spec/spec_helper')

class Proxiable
  attr_reader :attributes
  def initialize(attributes)
    @attributes = attributes
  end
end

# 'config.mock_with :flexmock' needed in spec_helper.rb

describe ResourceProxy::RailsCache do
  describe ".accept" do
    it "should not accept if neither :id nor :proxy is 'cache' in params" do
      result = ResourceProxy::RailsCache.accept(Proxiable, {:id => '1'}, {})
      result.should be_nil
    end
    
    it "should accept if params :id is 'cache'" do
      result = ResourceProxy::RailsCache.accept(Proxiable, {:id => 'cache'}, {})
      result.should be_kind_of(ResourceProxy::RailsCache)
    end

    it "should accept if params :proxy is 'cache'" do
      result = ResourceProxy::RailsCache.accept(Proxiable, {:proxy => 'cache'}, 
                                                {})
      result.should be_kind_of(ResourceProxy::RailsCache)
    end
    
    it "should call update_attributes on proxy if attributes given in params" do
      atts = flexmock('proxiable_attributes')
      proxy = flexmock('proxy')
      flexmock(ResourceProxy::RailsCache).should_receive(:new).\
        once.and_return(proxy)
      proxy.should_receive(:update_attributes).once.with(atts)
      ResourceProxy::RailsCache.accept(Proxiable, 
                                       {:proxy => 'cache',
                                        :proxiable => atts}, 
                                       {})
    end

    it "should store ok without subresources" do
      proxy = ResourceProxy::RailsCache.new(Proxiable)
      proxy.update_attributes(:att => 'val')
      proxy.attributes.should == {:att => 'val'}
      proxy.update_attributes(:att2 => 'val2')
      proxy.attributes.should == {:att => 'val', :att2 => 'val2'}
    end
    
  end
end
