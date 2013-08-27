require 'logger'

module Lou
  autoload :QueryBuilder, 'lou/query_builder'
  autoload :QueryStringParser, 'lou/query_string_parser'
  autoload :Version, 'lou/version'

  def self.setup(options={})
    if options[:logger]
      @logger = options[:logger]
    end
  end

  def self.logger
    @logger ||= ::Logger.new(STDERR)
  end


  def self.search(model, query_string, opts={})
    QueryBuilder.new(model, opts).query query_string
  end

  def self.query(model, query_string, opts={}) # depricated
    search model, query_string, opts
  end
end
