require "lou/version"

module Lou
  class QueryProxy
    attr_reader :model
    attr_reader :options

    def initialize(model, options)
      @model = model
      @options = options
    end

    def query(query_string)
      collection
    end

    def collection
      @model.all
    end
  end

  def self.query(model, opts)
    query = opts.delete :query
    QueryProxy.new(model, opts).query query
  end

end
