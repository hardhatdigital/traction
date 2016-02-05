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

    def web_registration(details={})
      body = {customer: details}

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
      elsif response.code == "401"
        { success: false, error: { code: 401, description: "Unauthorised Access", cause: "The API call was not authorised. Check your URL and password details." } }
      elsif response.code == "404"
        { success: false, error: { code: 404, description: "Invalid URL", cause: "The URL was incorrect. Check your URL and password details." } }
      elsif response.code == "503"
        { success: false, error: { code: 503, description: "API Unavailable", cause: "The API is currently unavailable for upgrade or maintenance." } }
      elsif response.code == "500"
        { success: false, error: { code: 500, description: "Other", cause: "Unrecoverable or unknown error - API server may be down" } }
      else
        { success: false, error: { code: 000, description: "Unknown", cause: "Unknown error, possibly internal to gem." } }
      end
    end

    def make_uri
      URI.parse("https://#{DOMAIN}/#{@path}")
    end
  end
end
