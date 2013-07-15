require 'spec_helper'

describe Lou::Search do
  it "works" do
    described_class.should be_kind_of Class
  end

  context "with query string 'last_name:eq=\"Juan Marco\"+category_id:in=1,2,3&limit=10&order:desc=id'" do
    let(:query_string) { "filter=last_name:eq=\"Juan Marco\"+category_id:in=1,2,3&limit=10&order:desc=id" }
    let(:search) { Lou::Search.new(query_string) }

    it "has a limit of 10" do
      search.limit.should be 10
    end
  end

end
