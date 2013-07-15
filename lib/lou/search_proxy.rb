module Lou
  class SearchProxy
    attr_reader :model
    attr_reader :options

    # author:eq=author where(author: author)
    # category_id:in=1,2,3 where(category_id: [1,2,3]
    # title:ne='shining' where.not(title: 'the shining')

    def initialize(model, options={})
      @model = model
      @options = options
    end

    def query(query_string)
      collection
    end

    private

    def collection
      @model.all
    end
  end
end
