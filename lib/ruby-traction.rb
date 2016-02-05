require "ruby-traction/version"
require "ruby-traction/web_connection"

class RubyTraction

  require "net/http"

  def initialize(password)
    @password = password
  end

  def web_connection(path)
    RubyTraction::WebConnection.new(path, @password)
  end
#
#  def self.customer_lookup(web_connection, lookup_params, attributes)
#    uri = URI.parse(web_connection)
#    data = {
#      customerLookup: lookup_params,
#      customerAttributes: attributes
#    }
#    Net::HTTP
#  end

end
