require "lou/version"

module Lou
  require 'lou/query_proxy'

  def self.query(model, opts)
    query = opts.delete :query
    QueryProxy.new(model, opts).query query
  end
end
