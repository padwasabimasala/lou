require 'cgi'
require 'shellwords'

module Lou
  class Search
    def initialize(query_string)
      @query_string = query_string || ""
    end

    def limit
      params["limit"].map(&:to_i).first
    end

    def order_by
      order.map(&:to_sym).first
    end

    def order_direction
      order.map(&:to_sym).last
    end

    def filter
      unless @filter
        parse_filter
      end
      @filter
    end

    def join
      unless @join
        parse_filter
      end
      @join
    end

    private

    def parse_filter
      @filter = {}
      #TODO @join = {}
      # ["last_name:eq=Juan de Marco", "category_id:in=1,2,3"] ; last_name:eq=\"Juan de Marco\"+category_id:in=1,2,3
      rules = ::Shellwords::shellwords (params["filter"].first || "")
      rules.each do |rule|
        attribute, operator_and_value = rule.split(':') # "category_id", "in=1,2,3"
        operator, value = operator_and_value.split('=') # "in", "1,2,3"              
        value = value.split(',') if operator == "in"    # ['1', '2', '3']
        # TODO check if the attribute is a virtual attribute if so create a "join" instead of a filter
        @filter[attribute.to_sym] = { operator: operator.to_sym, value: value }
      end
    end

    def params
      @params ||= ::CGI::parse @query_string
    end

    def order
      unless @order
        order_options = params["order"].first
        if order_options.nil?
          @order  = []
        elsif order_options =~ /:/
          @order = order_options.split(':')
        else
          @order = [order_options, nil]
        end
      end
      @order
    end

  end
end
