require 'spec_helper'

describe Lou::SearchProxy do
  # Example query customer_id:in=10,11,12+type:eq=1
  it "works" do
    described_class.should be_kind_of Class
  end

  # it "parses the query into where calls" do
  #   Person.any_instance.should_receive(:where).with(first_name: "david").and_call_original
  #   Person.any_instance.should_receive(:where).with(last_name: "benjesse").and_call_original
  #   Lou::SearchProxy.new(Person).query "filter=first_name:eq=david+last_name:eq=benjesse"
  # end

end
