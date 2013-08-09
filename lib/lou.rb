require 'lou/version'
require 'logger'

module Lou
  require 'lou/search_proxy'
  require 'lou/search'

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
