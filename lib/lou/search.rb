require 'cgi'
require 'shellwords'

module Lou
  class Search
    attr_reader :order, :joins, :selectors

    def initialize(query_string, options={})
      @query_string = query_string || ""
      @options = options
      @order = []
      @joins = Hash.new {|h,k| h[k] = []}
      @selectors = {}
      parse_order
      parse_filter
    end

    def limit
      @limit ||= params["limit"].map(&:to_i).first
    end

    def order_by
      order.map(&:to_sym).first
    end

    def order_direction
      order.map(&:to_sym).last
    end

    private

    def params
      @params ||= ::CGI::parse @query_string
    end

    def parse_order
      order_options = params["order"].first
      if order_options.nil?
        @order  = []
      elsif order_options =~ /:/
        @order = order_options.split(':')
      else
        @order = [order_options, nil]
      end
    end

    def parse_filter
      rules do |rule|
        virtual_attr = virtual_attributes[rule[:attribute]]
        if virtual_attr
          join = virtual_attr[:joins]
          @joins[join] << rule
        else
          attribute = rule.delete :attribute
          @selectors[attribute] = rule
        end
      end
    end

    def rules
      # ["last_name:eq=Juan de Marco", "category_id:in=1,2,3"] ; last_name:eq=\"Juan de Marco\"+category_id:in=1,2,3
      rules = ::Shellwords::shellwords (params["filter"].first || "")
      rules.each do |rule|
        yield parse_rule rule
      end
    end

    def parse_rule rule
      attribute, operator_and_value = rule.split(':') # "category_id", "in=1,2,3"
      operator, value = operator_and_value.split('=') # "in", "1,2,3"
      value = value.split(',') if operator == "in"    # ['1', '2', '3']
      { attribute: attribute.to_sym, operator: operator.to_sym, value: value }
    end

    def virtual_attributes
      @virtual_attributes ||= (@options[:virtual_attributes] || {})
    end
  end
end
