require 'spec_helper'

describe Lou::SearchProxy do
  it "works" do
    described_class.should be_kind_of Class
  end

  it "parses the query into ActiveRecord query chain" do
    PersonMock.should_receive(:where).with(first_name: "david").and_call_original
    PersonMock.should_receive(:where).with().and_call_original
    PersonMock.should_receive(:not).with(last_name: "benjesse").and_call_original
    PersonMock.should_receive(:where).with(category_id: ["1", "2", "3"]).and_call_original
    PersonMock.should_receive(:limit).with(10).and_call_original
    PersonMock.should_receive(:order).with("id desc").and_call_original
    Lou::SearchProxy.new(PersonMock).query "filter=first_name:eq=david+last_name:ne=benjesse+category_id:in=1,2,3&limit=10&order=id:desc"
  end

end
