require 'spec_helper'

describe Lou::QueryBuilder do
  it "parses the query into ActiveRecord query chain" do
    PersonMock.should_receive(:joins).with(:employees).and_call_original
    PersonMock.should_receive(:where).with(employees: { company_id: "33" }).and_call_original
    PersonMock.should_receive(:where).with(employees: { employee_id: ["9","8","7"] }).and_call_original
    PersonMock.should_receive(:where).with(first_name: "david").and_call_original
    PersonMock.should_receive(:where).with("last_name != ?", "benjesse").and_call_original
    PersonMock.should_receive(:where).with(category_id: ["1", "2", "3"]).and_call_original
    PersonMock.should_receive(:limit).with(10).and_call_original
    PersonMock.should_receive(:order).with("id desc").and_call_original
    options = { virtual_attributes: { company_id: { joins: :employees }, employee_id: { joins: :employees } }}
    described_class.new(PersonMock, options).query "filter=first_name:eq=david+last_name:ne=benjesse+category_id:in=1,2,3+company_id:eq=33+employee_id:in=9,8,7&limit=10&order=id:desc"
  end

  it "handles empty query string" do
    PersonMock.should_receive(:all).and_call_original
    described_class.new(PersonMock).query ""
  end

  it "handles nil query string" do
    PersonMock.should_receive(:all).and_call_original
    described_class.new(PersonMock).query nil
  end
end
