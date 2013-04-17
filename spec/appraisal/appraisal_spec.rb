require 'spec_helper'
require 'appraisal/appraisal'
require 'tempfile'

describe Appraisal::Appraisal do
  it "creates a proper bundle command" do
    appraisal = Appraisal::Appraisal.new('fake', 'fake')
    appraisal.stub(:gemfile_path).and_return("/home/test/test directory")

    appraisal.bundle_command.should == "bundle check --gemfile='/home/test/test directory' || bundle install --gemfile='/home/test/test directory'"
  end

  it "converts spaces to underscores in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("one two", "Gemfile")
    appraisal.gemfile_path.should =~ /one_two\.gemfile$/
  end

  it "converts  punctuation to underscores in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("o&ne!", "Gemfile")
    appraisal.gemfile_path.should =~ /o_ne_\.gemfile$/
  end

  it "keeps dots in the gemfile path" do
    appraisal = Appraisal::Appraisal.new("rails3.0", "Gemfile")
    appraisal.gemfile_path.should =~ /rails3\.0\.gemfile$/
  end

  describe "with tempfile output" do
    before do
      @output = Tempfile.new('output')
    end
    after do
      @output.close
      @output.unlink
    end

    it "gemfile end with one newline" do
      appraisal = Appraisal::Appraisal.new('fake', 'fake')
      appraisal.stub(:gemfile_path) { @output.path }
      appraisal.write_gemfile
      @output.read.should =~ /[^\n]*\n\z/m
    end
  end
end
