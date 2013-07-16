require 'spec_helper'

describe Lou::Search do
  it "works" do
    described_class.should be_kind_of Class
  end

  context "with query string 'last_name:eq=\"Juan de Marco\"+category_id:in=1,2,3&limit=10&order=id:desc'" do
    let(:query_string) { "filter=last_name:eq=\"Juan de Marco\"+category_id:in=1,2,3&limit=10&order=id:desc" }
    let(:search) { Lou::Search.new(query_string) }

    it "has a limit of 10" do
      search.limit.should be 10
    end

    it "has an order_by of id" do
      search.order_by.should eq "id"
    end

    it "has an order_direction of desc" do
      search.order_direction.should eq "desc"
    end

    it "has the correct filter" do
      search.filter["last_name"].should eq({ operator: "eq", value: 'Juan de Marco' })
      search.filter["category_id"].should eq ({ operator: "in", value: ['1', '2', '3'] })
    end

  end
end
