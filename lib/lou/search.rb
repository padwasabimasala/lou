require 'cgi'
require 'shellwords'

module Lou
  class Search
    def initialize(query_string, options={})
      @query_string = query_string || ""
      @options = options
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

    def joins
      unless @join
        parse_filter
      end
      @join
    end

    private

    def parse_filter
      @filter = {}
      @join = {}
      # ["last_name:eq=Juan de Marco", "category_id:in=1,2,3"] ; last_name:eq=\"Juan de Marco\"+category_id:in=1,2,3
      rules = ::Shellwords::shellwords (params["filter"].first || "")
      rules.each do |rule|
        attribute, operator, value = parse_rule rule

        join_assoc_val = join_assoc attribute
        if join_assoc_val
          @join[join_assoc_val] = [] unless @join.key? join_assoc_val
          @join[join_assoc_val] << { attribute: attribute, operator: operator, value: value }
        else
          @filter[attribute] = { operator: operator, value: value }
        end
      end
    end

    def parse_rule rule
      attribute, operator_and_value = rule.split(':') # "category_id", "in=1,2,3"
      operator, value = operator_and_value.split('=') # "in", "1,2,3"
      value = value.split(',') if operator == "in"    # ['1', '2', '3']
      [attribute.to_sym, operator.to_sym, value]
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

    def virtual_attribute attribute_name
      if @options.key? :virtual_attributes
        attribute = @options[:virtual_attributes].detect { |attrib| attrib.has_key? attribute_name }
        attribute[attribute_name] if attribute
      end
    end

    def join_assoc attribute_name
      attribute = virtual_attribute attribute_name
      attribute[:joins] if attribute
    end


  end
end
