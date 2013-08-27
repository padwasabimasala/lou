require 'lou/version'
require 'logger'

module Lou
  require 'lou/query_string_parser'
  require 'lou/search_proxy'

  def self.setup(options={})
    if options[:logger]
      @logger = options[:logger]
    end
  end

  def self.logger
    @logger ||= ::Logger.new(STDERR)
  end

  def self.query(model, query_string, opts={}) # rename search
    SearchProxy.new(model, opts).query query_string
  end
end
