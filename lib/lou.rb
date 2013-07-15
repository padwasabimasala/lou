require "lou/version"

module Lou
  require 'lou/search_proxy'
  require 'lou/search'

  def self.query(model, query_string, opts={}) # rename search
    SearchProxy.new(model, opts).query query_string
  end
end
