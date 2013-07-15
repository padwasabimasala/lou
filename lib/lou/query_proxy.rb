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
end
