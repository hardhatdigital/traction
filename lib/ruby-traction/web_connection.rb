require "json"
require "net/http"

class RubyTraction
  class WebConnection
    DOMAIN = "int.api.tractionplatform.com"

    def initialize(path, password)
      @path = path
      @password = password
    end

    def get_customer(field, value, attributes=[])
      body = {customerLookup: {field => value},
              customerAttributes: attributes}

      respond_to(body)
    end

    def add_customer_with_group_and_subscription(details={}, groups={}, subscriptions={})
      body = {customer: details,
              groups: groups,
              subscriptions: subscriptions}

      respond_to(body)
    end

   private

    def respond_to(body)
      handle_response(
        make_request(body))
    end

    def make_request(body)
      uri = make_uri()

      Net::HTTP.post_form(uri, {data: body.to_json, password: @password})
    end

    def handle_response(response)
      if response.code == "200"
        JSON.parse(response.body)
      else
        {:success => false}
      end
    end

    def make_uri
      URI.parse("https://#{DOMAIN}/#{@path}")
    end
  end
end
