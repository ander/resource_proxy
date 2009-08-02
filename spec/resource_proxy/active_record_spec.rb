require File.expand_path(File.dirname(__FILE__)+'/../../../../../spec/spec_helper')

class Proxiable
  
end

# 'config.mock_with :flexmock' needed in spec_helper.rb

describe ResourceProxy::ActiveRecord do
  describe ".accept" do
    it "should call find with opts if params[:id]" do
      opts = flexmock('opts')
      flexmock(Proxiable).should_receive(:find).once.with('1', opts)
      ResourceProxy::ActiveRecord.accept(Proxiable, {:id => '1'}, opts)
    end

    it "should call new with attributes if no params[:id]" do
      opts = flexmock('opts')
      atts = flexmock('proxiable attributes')
      flexmock(Proxiable).should_receive(:new).once.with(atts)
      ResourceProxy::ActiveRecord.accept(Proxiable, {:proxiable => atts}, opts)
    end

  end
end
