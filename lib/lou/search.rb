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

    def filter
      params[:filter].map do |rule| 
        escaped_rule = ::Shellword::shellwords rule                # "first_name:eq"first_name:eq=\"
        attribute, operator_and_value = escapted_rule.split(':')
        operator, value = operator_and_value.split('=')
      end
    end

  end
end
