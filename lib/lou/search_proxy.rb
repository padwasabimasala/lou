module Lou
  class SearchProxy
    require 'cgi'
    require 'shellwords'

    attr_reader :collection

    def initialize(model, options={})
      @model = model
      @options = options
      @collection = model
      @options = options
    end

    def query(query_string)
      if query_string
        # refactor parse_query_string \n apply_joins
        search = QueryStringParser.new query_string, @options
        apply_joins search
        apply_selectors search
        apply_order search
        apply_limit search
      end
      finalize_collection
    end

    private

    def apply_joins(search)
      # joins {:employees=>[ .. ]}
      search.joins.each do |table_name, params| 
        @collection = collection.joins(table_name)
        # params {:attribute=>:company_id, :operator=>:eq, :value=>"77"}, {:attribute=>:employee_id, :operator=>:in, :value=>["4", "5"]}
        params.each do |params|
          # Person.where(employees: {company_id: 1})
          attribute, value, operator = params[:attribute], params[:value], params[:operator]
          case operator
          when :eq
            @collection = collection.where(table_name => { attribute => value })
          when :in
            @collection = collection.where(table_name => { attribute => value })
          when :ne
            @collection = collection.where(table_name => ["#{attribute} != ?", value])
          end
        end
      end
    end

    def apply_selectors(search)
      search.selectors.each do |attribute, params| # first_name, { value: 'matthew', operator: :eq }
        value, operator = params[:value], params[:operator]
        case params[:operator]
        when :eq
          @collection = collection.where(attribute => value)
        when :in
          @collection = collection.where(attribute => value)
        when :ne
          @collection = collection.where("#{attribute} != ?", value)
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
