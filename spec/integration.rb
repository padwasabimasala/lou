require 'spec_helper'
require 'active_record'
 
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database  => ":memory:")
 
ActiveRecord::Schema.define do
  create_table :people do |t|
    t.column :first_name, :string
    t.column :last_name, :string
  end

  create_table :companies do |t|
    t.column :name, :string
  end

  create_table :employees do |t|
    t.column :person_id, :integer
    t.column :company_id, :integer
    t.column :employee_id, :string
  end
end
 
class Person < ActiveRecord::Base; end
class Company < ActiveRecord::Base; end
class Employee < ActiveRecord::Base; end

describe Lou do
  $bob = Person.create first_name: :bob, last_name: :smith
  $ada = Person.create first_name: :ada, last_name: :doe
  $dub = Person.create first_name: :dub, last_name: :smith
  $cam = Person.create first_name: :cam, last_name: :jones
  $eli = Person.create first_name: :eli, last_name: :smith

  $octanner = Company.create name: "O.C. Tanner"
  $tadlyco = Company.create name: "Tadly Co"

  Employee.create person_id: $bob.id, company_id: $octanner.id, employee_id: 1234
  Employee.create person_id: $ada.id, company_id: $octanner.id, employee_id: "abcd"
  Employee.create person_id: $dub.id, company_id: $octanner.id, employee_id: "zyx9"
  Employee.create person_id: $cam.id, company_id: $tadlyco.id, employee_id: 1234
  Employee.create person_id: $eli.id, company_id: $tadlyco.id, employee_id: 5678

  describe "order" do
    it "orders asc" do
      Lou.query(Person, "order=first_name:asc").map{|p| p.first_name}.should eq ['ada', 'bob', 'cam', 'dub', 'eli']
    end

    it "orders desc" do
      Lou.query(Person, "order=first_name:desc").map{|p| p.first_name}.should eq ["eli", "dub", "cam", "bob", "ada"]
    end
  end

  describe "limit" do
    it "limits results" do
      Lou.query(Person, "").size.should be 5
      Lou.query(Person, "limit=4").size.should be 4
    end
  end

  describe "filter" do
    it "finds matching" do
      Lou.query(Person, "filter=last_name:eq=smith").size.should be 3
    end

    it "finds non matching" do
      Lou.query(Person, "filter=last_name:ne=smith").size.should be 2
    end
    
    it "finds by inclusion" do
      Lou.query(Person, "filter=last_name:in=smith,jones").size.should be 4
    end

    it "finds with more than one filter" do
      Lou.query(Person, "filter=last_name:eq=smith+first_name:ne=dub").size.should be 2
    end
  end

  describe "filter order and limit" do
    it "filters orders and limits" do
      Lou.query(Person, "filter=last_name:eq=smith&order=first_name:desc&limit=2").map{|p| p.first_name}.should eq ["eli", "dub"]
    end
  end

  context "with a nil query string" do
    it "returns all records" do
      Lou.query(Person, nil).map{|p| p.first_name}.should eq ['bob', 'ada', 'dub', 'cam', 'eli']
    end
  end

  context "with an empty query string" do
    it "returns all records" do
      Lou.query(Person, nil).map{|p| p.first_name}.should eq ['bob', 'ada', 'dub', 'cam', 'eli']
    end
  end
end
