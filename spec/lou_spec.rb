require 'spec_helper'

describe Lou do
  it "works" do
    Lou.should be_kind_of Module
  end

  describe ".setup" do
    it "can set the logger" do
      Lou.logger.should be_a Logger
      Lou.setup logger: :stub_logger
      Lou.logger.should be :stub_logger
    end
  end

  context "with nil query string" do
    let(:query_string) { nil }

    it "returns all records" do
      PersonMock.should_receive(:all).and_call_original
      res = Lou.query PersonMock, query_string
      res.should be PersonMock
    end
  end

  context "with empty query string" do
    let(:query_string) { '' }

    it "returns all records" do
      PersonMock.should_receive(:all).and_call_original
      res = Lou.query PersonMock, query_string
      res.should be PersonMock
    end
  end
end
