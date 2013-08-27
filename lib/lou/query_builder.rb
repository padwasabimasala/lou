module Lou
  class QueryBuilder
    require 'cgi'
    require 'shellwords'

    attr :collection

    def initialize(model, options={})
      @model = model
      @options = options
      @collection = model
      @options = options
      @conditions_log = ["#{@model}"]
    end

    def query(query_string)
      if query_string
        search = QueryStringParser.new query_string, @options
        apply_joins search
        apply_selectors search
        apply_order search
        apply_limit search
      end
      apply_finalize
      collection
    end

    private

    def apply_joins(search)
      # joins {:employees=>[ .. ]}
      search.joins.each do |table_name, params| 
        append_condition :joins, table_name
        # params {:attribute=>:company_id, :operator=>:eq, :value=>"77"}, {:attribute=>:employee_id, :operator=>:in, :value=>["4", "5"]}
        params.each do |params|
          # Person.where(employees: {company_id: 1})
          attribute, value, operator = params[:attribute], params[:value], params[:operator]
          case operator
          when :eq
            append_condition :where, { table_name => { attribute => value }}
          when :in
            append_condition :where, { table_name => { attribute => value }}
          when :ne
            append_condition :where, { table_name => ["#{attribute} != ?", value] }
          end
        end
      end
    end

    def apply_selectors(search)
      search.selectors.each do |attribute, params| # first_name, { value: 'matthew', operator: :eq }
        value, operator = params[:value], params[:operator]
        case params[:operator]
        when :eq
          append_condition :where, { attribute => value }
        when :in
          append_condition :where, { attribute => value }
        when :ne
          append_condition :where, ["#{attribute} != ?", value]
        end
      end
    end

    def apply_order(search)
      append_condition :order, { search.order_by.to_sym => search.order_direction.to_sym } if search.order_by
    end

    def apply_limit(search)
      append_condition :limit, search.limit if search.limit
    end

    def append_condition(method, params=nil)
      @conditions_log << ".#{method}(#{params.inspect if params})" 
      params = [params] unless params.kind_of? Array
      @collection = collection.send(method, *params)
    end

    def apply_finalize
      append_condition :all
      Lou.logger.info "final query conditions: #{@conditions_log.join ''}"
    end
  end
end
