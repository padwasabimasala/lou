require 'spec_helper'

describe Lou::SearchProxy do
  # Example query customer_id:in=10,11,12+type:eq=1
  it "works" do
    described_class.should be_kind_of Class
  end
end
