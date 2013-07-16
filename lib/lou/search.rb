require 'cgi'
require 'shellwords'

module Lou
  class Search
    attr_reader :query_string

    def initialize(query_string)
      @query_string = query_string
    end

    def limit
      params["limit"].first.to_i
    end

    def order_by
      order.first
    end

    def order_direction
      order.last
    end

    def filter
      unless @filter
        @filter = {}
        rules = ::Shellwords::shellwords params["filter"].first
        rules.each do |rule|
          attribute, operator_and_value = rule.split(':')
          operator, value = operator_and_value.split('=')
          value = value.split(',') if operator == "in"
          @filter[attribute] = { operator: operator, value: value }
        end
      end
      @filter
    end

    private

    def params
      @params ||= ::CGI::parse query_string
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
    end

  end
end
