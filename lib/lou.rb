require "lou/version"

module Lou
  require 'lou/search_proxy'

  def self.query(model, query_string, opts={})
    SearchProxy.new(model, opts).query query_string
  end
end
