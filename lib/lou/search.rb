require 'cgi'
require 'shellwords'

module Lou
  class Search
    attr_reader :query_string

    def initialize(query_string)
      @query_string = query_string
    end

    def params
      @params ||= ::CGI::parse query_string
    end

    def filter
      params[:filter].map do |rule| 
        escaped_rule = ::Shellword::shellwords rule                # "first_name:eq"first_name:eq=\"
        attribute, operator_and_value = escapted_rule.split(':')
        operator, value = operator_and_value.split('=')
      end
    end

    def limit
      params["limit"].first.to_i
    end
  end
end
