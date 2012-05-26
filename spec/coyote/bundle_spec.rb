require 'coyote/bundle'

describe Coyote::Bundle do
  before :each do
    @bundle = Coyote::Bundle.new      
  end

  context "#add" do
    it "adds an input to the bundle" do
      @bundle.add("spec/assets/bundle/javascript/script1.js")
      @bundle.assets.should have_key File.expand_path("spec/assets/bundle/javascript/script1.js")
    end
    
    it "adds an input's dependencies" do
      @bundle.add("spec/assets/bundle/javascript/script3.js")      
      @bundle.assets.should have_key File.expand_path("spec/assets/bundle/javascript/script3.js")
      @bundle.assets.should have_key File.expand_path("spec/assets/bundle/javascript/script4.js")
    end
    
    it "doesn't add the same dependency twice" do
      @bundle.add("spec/assets/bundle/javascript/script1.js")
      @bundle.add("spec/assets/bundle/javascript/script1.js")
      @bundle.assets.length.should == 1
    end
  end
  
  context "#empty!" do
    it "removes all of its assets" do
      @bundle.add("spec/assets/bundle/javascript/script1.js")
      @bundle.empty!
      @bundle.assets.should be_empty
    end
    
    it "removes all of the bundle's contents" do
      @bundle.add("spec/assets/bundle/javascript/script1.js")
      @bundle.empty!
      @bundle.contents.should be_empty
    end
  end

  context "#contents" do
    it "returns the contents of all of its assets" do
      @bundle.add("spec/assets/bundle/javascript/script1.js")
      @bundle.add("spec/assets/bundle/javascript/script2.js")
      contents = IO.read("spec/assets/bundle/javascript/script1.js") + IO.read("spec/assets/bundle/javascript/script2.js")
      @bundle.contents.should == contents
    end
  end
end




