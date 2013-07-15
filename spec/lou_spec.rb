require 'spec_helper'

describe Lou do
  it "works" do
    Lou.should be_kind_of Module
  end

  context "with nil query" do
    let(:query) { nil }

    it "returns all records" do
      Person.should_receive(:all) { :all_records }
      res = Lou.query Person, query: query
      res.should be :all_records
    end
  end

end
