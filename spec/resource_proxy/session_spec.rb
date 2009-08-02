require File.expand_path(File.dirname(__FILE__)+'/../../../../../spec/spec_helper')

class Proxiable
  attr_reader :attributes
  def initialize(attributes)
    @attributes = attributes
  end
end

# 'config.mock_with :flexmock' needed in spec_helper.rb

describe ResourceProxy::Session do
  describe ".accept" do
    it "should not accept if neither :id nor :proxy is 'session' in params" do
      result = ResourceProxy::Session.accept(Proxiable, {:id => '1'}, {})
      result.should be_nil
    end
    
    it "should accept if params :id is 'session'" do
      result = ResourceProxy::Session.accept(Proxiable, {:id => 'session'}, 
                                             {:store => Hash.new})
      result.should be_kind_of(ResourceProxy::Session)
    end

    it "should accept if params :proxy is 'session'" do
      result = ResourceProxy::Session.accept(Proxiable, {:proxy => 'session'}, 
                                             {:store => Hash.new})
      result.should be_kind_of(ResourceProxy::Session)
    end
    
    it "should call update_attributes on proxy if attributes given in params" do
      atts = flexmock('proxiable_attributes')
      proxy = flexmock('proxy')
      flexmock(ResourceProxy::Session).should_receive(:new).\
        once.and_return(proxy)
      proxy.should_receive(:update_attributes).once.with(atts)
      ResourceProxy::Session.accept(Proxiable, 
                                    {:proxy => 'session',
                                     :proxiable => atts}, 
                                    {:store => Hash.new})
    end

    it "should store ok without subresources" do
      proxy = ResourceProxy::Session.new(Proxiable, {:store => Hash.new})
      proxy.update_attributes(:att => 'val')
      proxy.attributes.should == {:att => 'val'}
      proxy.update_attributes(:att2 => 'val2')
      proxy.attributes.should == {:att => 'val', :att2 => 'val2'}
    end
    
  end
end
