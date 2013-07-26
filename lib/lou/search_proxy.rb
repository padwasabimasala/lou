require 'cgi'
require 'shellwords'

module Lou
  class SearchProxy
    attr_reader :collection

    def initialize(model, options={})
      @model = model
      @options = options
      @collection = model
      @options = options
    end

    def query(query_string)
      if query_string
        search = Search.new query_string, @options
        apply_joins search
        apply_selectors search
        apply_order search
        apply_limit search
      end
      finalize_collection
    end

    private

    def apply_joins(search)
      search.join.each do |join_assoc, params_list|
        @collection = collection.joins(join_assoc)

        values = {}
        params_list.each do |params|
          values[params[:attribute]] = params[:value]
        end

        @collection = collection.where(join_assoc => values)
      end
    end

    def apply_selectors(search)
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

    def finalize_collection
      @collection.all
    end
  end
end
