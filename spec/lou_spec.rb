require 'spec_helper'

describe Lou do
  describe ".setup" do
    let(:logger) { Logger.new(STDERR) } #stub(:logger, fatal: nil, error: nil, warn: nil, info: nil, debug: nil) }

    it "can set the logger" do
      Lou.logger.should be_a Logger
      Lou.setup logger: logger
      Lou.logger.should be logger
    end
  end

  describe ".search" do
    context "with nil query string" do
      let(:query_string) { nil }

      it "returns all records" do
        PersonMock.should_receive(:all).and_call_original
        res = Lou.search PersonMock, query_string
        res.should be PersonMock
      end
    end

    context "with empty query string" do
      let(:query_string) { '' }

      it "returns all records" do
        PersonMock.should_receive(:all).and_call_original
        res = Lou.search PersonMock, query_string
        res.should be PersonMock
      end
    end
  end

  describe ".query" do
    it "delegates to search" do
      Lou.should_receive(:search).with(:model, :query_string, :opts)
      Lou.query :model, :query_string, :opts
    end
  end
end
