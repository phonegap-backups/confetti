require 'spec_helper'

describe Confetti::Template::IosInfo do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::IosInfo
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"ios_info.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/ios_info.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :bundle_identifier }
    it { should respond_to :product_name }
    it { should respond_to :bundle_version }
  end

  describe "default values" do
    it "should define output filename as \"Info.plist\"" do
      @template_class.new.output_filename.should == "Info.plist"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"
      @config.version = "1.0.0"
    end

    it "should accept the config object" do
      lambda {
        @template_class.new(@config)
      }.should_not raise_error
    end

    describe "templated attributes" do
      before do
        @template = @template_class.new(@config)
      end

      it "should set bundle_identifier correctly" do
        @template.bundle_identifier.should == "com.whoever.awesome.app"
      end

      it "should set product_name correctly" do
        @template.product_name.should == "Awesome App"
      end

      it "should set bundle_version correctly" do
        @template.bundle_version.should == "1.0.0"
      end

      it "should render the correct Info.plist" do
        @template.render.should == File.read("#{ fixture_dir }/ios_info_spec.plist")
      end
    end
  end
end
