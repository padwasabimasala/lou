require 'spec_helper'

describe Lou::QueryStringParser do
  context "with with kitchen sink (virtual attributes, filter, orders, and limit)" do
    let(:query_string) { "filter=last_name:eq=\"Juan de Marco\"+category_id:in=1,2,3+company_id:eq=77+employee_id:in=4,5&limit=10&order=id:desc" }
    let(:search) { described_class.new(query_string, options) }
    let(:options) {{ 
      virtual_attributes: {
        company_id: { joins: :employees },
        employee_id: { joins: :employees } 
      }
    }}

    it "has a limit of 10" do
      search.limit.should be 10
    end

    it "has an order_by of id" do
      search.order_by.should eq :id
    end

    it "has an order_direction of desc" do
      search.order_direction.should eq :desc
    end

    it "has the correct selectors" do
      search.selectors.size.should eq 2
      search.selectors[:last_name].should eq({ operator: :eq, value: 'Juan de Marco' })
      search.selectors[:category_id].should eq ({ operator: :in, value: ['1', '2', '3'] })
    end

    it "has the correct joins" do
      search.joins.size.should eq 1
      search.joins[:employees].should =~ [
        { attribute: :company_id, operator: :eq, value: '77' },
        { attribute: :employee_id, operator: :in, value: ['4', '5'] }]
    end
  end

  context "with with virtual attributes in the options" do
    let(:search) { described_class.new(query_string, options) }
    let(:options) {{ 
      virtual_attributes: {
        company_id: { joins: :employees },
        employee_id: { joins: :employees } 
      }
    }}

    context "with virtual attributes in the query string" do
      let(:query_string) { "filter=last_name:eq=\"Juan de Marco\"+company_id:eq=77+employee_id:in=4,5" }

      it "has the correct joins" do
        search.joins.size.should eq 1
        search.joins[:employees].should =~ [
          { attribute: :company_id, operator: :eq, value: '77' },
          { attribute: :employee_id, operator: :in, value: ['4', '5'] }]
      end
    end

    context "with no virtual attributes in the query string" do
      let(:query_string) { "filter=last_name:eq=\"Juan de Marco\"" }

      it "has the correct joins" do
        search.joins.size.should eq 0
      end
    end
  end

  context "with nil query string" do
    let(:query_string) { nil }
    let(:search) { described_class.new(query_string) }

    it "has a limit of nil" do
      search.limit.should be nil
    end

    it "has an order_by of nil" do
      search.order_by.should eq nil
    end

    it "has an order_direction of nil" do
      search.order_direction.should eq nil
    end

    it "has no selectors" do
      search.selectors.should eq({})
    end
  end

  context "with an empty query string" do
    let(:query_string) { "" }
    let(:search) { described_class.new(query_string) }

    it "has a limit of nil" do
      search.limit.should be nil
    end

    it "has an order_by of nil" do
      search.order_by.should eq nil
    end

    it "has an order_direction of nil" do
      search.order_direction.should eq nil
    end

    it "has no selectors" do
      search.selectors.should eq({})
    end
  end
end
