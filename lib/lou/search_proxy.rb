require 'cgi'
require 'shellwords'

module Lou
  class SearchProxy
    # author:eq=author where(author: author)
    # category_id:in=1,2,3 where(category_id: [1,2,3]
    # title:ne='shining' where.not(title: 'the shining')
    #
    attr_reader :collection

    def initialize(model, options={})
      @model = model
      @options = options
      @collection = model.all
    end

    def query(query_string)
      return collection if !query_string
      search = Search.new query_string
      apply_filter search
      apply_order search
      apply_limit search
      collection
    end

    private 

    def apply_filter(search)
      search.filter.each do |attribute, params|
        value = params[:value]
        case params[:operator]
        when :eq
          @collection = collection.where(attribute => value)
        when :in
          @collection = collection.where(attribute => value)
        when :ne
          @collection = collection.where.not(attribute => value)
        end
      end
    end

    def apply_order(search)
      @collection = collection.order("#{search.order_by} #{search.order_direction}")
    end

    def apply_limit(search)
      @collection = collection.limit(search.limit)
    end
  end
end
