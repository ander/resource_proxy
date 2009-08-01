require File.expand_path(File.dirname(__FILE__)+'/../../../../spec/spec_helper')

class Proxiable
  extend ResourceProxy::Finder
end

# 'config.mock_with :flexmock' needed in spec_helper.rb

describe ResourceProxy do
  
  describe "ResourceProxy::Finder.find_proxy" do
    before :each do
      @first = flexmock('first proxy')
      @second = flexmock('second proxy')
      @params = flexmock('params')
      flexmock(ResourceProxy).should_receive(:all).and_return(
        {:first => @first, :second => @second})
    end
    
    it "should call accept on first proxy only if it accepts" do
      @first.should_receive(:accept).once.with(Proxiable, @params, {}).\
        and_return(flexmock('a proxy'))
      @second.should_receive(:accept).never
      
      Proxiable.find_proxy(@params, [:first, :second])
    end

    it "should call accept on second proxy if first doesn't accept" do
      @first.should_receive(:accept).once.with(Proxiable, @params, {}).\
        and_return(nil)
      @second.should_receive(:accept).once.with(Proxiable, @params, {}).\
        and_return(flexmock('a proxy'))
      
      Proxiable.find_proxy(@params, [:first, :second])
    end

    it "should raise if no proxy found" do
      @first.should_receive(:accept).once.with(Proxiable, @params, {}).\
        and_return(nil)
      @second.should_receive(:accept).once.with(Proxiable, @params, {}).\
        and_return(nil)
      
      lambda{ Proxiable.find_proxy(@params, [:first, :second])}.should \
        raise_error
    end
    
    it "should pass options correctly with accept" do
      first_opts = flexmock('first opts')
      second_opts = flexmock('second opts')
      
      @first.should_receive(:accept).once.with(Proxiable, @params, 
        first_opts).and_return(nil)
      @second.should_receive(:accept).once.with(Proxiable, @params,
        second_opts).and_return(flexmock('a proxy'))
      
      Proxiable.find_proxy(@params, [:first, :second], first_opts, second_opts)
    end
  end
  
end
