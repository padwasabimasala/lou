require 'spec_helper'

describe Lou do
  it "works" do
    Lou.should be_kind_of Module
  end

  context "with nil query string" do
    let(:query_string) { nil }

    it "returns all records" do
      Person.should_receive(:all).and_call_original
      res = Lou.query Person, query_string
      res.should be Person
    end
  end

  context "with empty query string" do
    let(:query_string) { '' }

    it "returns all records" do
      Person.should_receive(:all).and_call_original
      res = Lou.query Person, query_string
      res.should be Person
    end
  end
end
