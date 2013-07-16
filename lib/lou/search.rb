require 'cgi'
require 'shellwords'

module Lou
  class Search
    def initialize(query_string)
      @query_string = query_string
    end

    def limit
      params["limit"].first.to_i
    end

    def order_by
      order.first.to_sym
    end

    def order_direction
      order.last.to_sym
    end

    def filter
      unless @filter
        @filter = {}
        # ["last_name:eq=Juan de Marco", "category_id:in=1,2,3"] ; last_name:eq=\"Juan de Marco\"+category_id:in=1,2,3
        rules = ::Shellwords::shellwords params["filter"].first 
        rules.each do |rule|
          attribute, operator_and_value = rule.split(':') # "category_id", "in=1,2,3"
          operator, value = operator_and_value.split('=') # "in", "1,2,3"              
          value = value.split(',') if operator == "in"    # ['1', '2', '3']
          @filter[attribute.to_sym] = { operator: operator.to_sym, value: value }
        end
      end
      @filter
    end

    private

    def params
      @params ||= ::CGI::parse @query_string
    end

    def order
      unless @order
        order_options = params["order"].first
        if order_options =~ /:/
          @order = order_options.split(':')
        else
          @order = [order_options, nil]
        end
      end
      @order
    end

  end
end
