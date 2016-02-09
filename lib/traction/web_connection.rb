require "json"
require "net/http"

class Traction
  class WebConnection
    DOMAIN = "int.api.tractionplatform.com"

    def initialize(path, password)
      @path = path
      @password = password
    end

    #### REGISTRATION METHODS ####
    
    def get_customer_by(field, value, attributes=[])
      body = {customerLookup: {field => value},
              customerAttributes: attributes}

      get_response_for(body)
    end

    def add_customer(details={}, optional_data={})
      body = {customer: details,
              transData: optional_data}

      get_response_for(body)
    end

    def add_customer_with_group_and_subscription(details={}, groups={}, subscriptions={})
      body = {customer: details,
              groups: groups,
              subscriptions: subscriptions}

      get_response_for(body)
    end

    def web_registration(details={}, optional_data={})
      body = {customer: details,
              transData: optional_data}

      get_response_for(body)
    end

    #### COMPETITION METHODS ####

    def validate_competition_entrant(field, value, entry_code)
      body = {mode: "VALIDATE",
              customer: {field => value},
              entryCode: entry_code}
       
      get_response_for(body)
    end

    def add_competition_entrant(details={}, entry_code, subscriptions={}, optional_data={})
      body = {customer: details,
              entryCode: entry_code,
              subscriptions: subscriptions,
              transData: optional_data}
       
      get_response_for(body)
    end

    def draw_competition(venue_ids=[])
      body = {mode: "DRAW"}
      body[:venueIdList] = venue_ids if venue_ids.any?

      get_response_for(body)
    end

    def redeem_competition_entrant(field, value, venue_id, redemption_code, optional_data={})
      body = {mode: "REDEEM",
              customer: {field => value},
              venueId: venue_id,
              redemptionCode: redemption_code,
              transData: optional_data}

      get_response_for(body)
    end

    #### TRIGGERED MESSAGE METHODS ####

    def send_triggered_email(email, content={})
      body = {customer: {EMAIL: email},
              transData: content}

      get_response_for(body)
    end

   private

    def get_response_for(body)
      handle_response(
        make_request(body))
    end

    def make_request(body)
      uri = make_uri()

      Net::HTTP.post_form(uri, {data: body.to_json, password: @password})
    end

    def handle_response(response)
      case response.code
      when "200"
        JSON.parse(response.body)
      when "401"
        { success: false, error: { code: 401, description: "Unauthorised Access", cause: "The API call was not authorised. Check your URL and password details." } }
      when "404"
        { success: false, error: { code: 404, description: "Invalid URL", cause: "The URL was incorrect. Check your URL and password details." } }
      when "503"
        { success: false, error: { code: 503, description: "API Unavailable", cause: "The API is currently unavailable for upgrade or maintenance." } }
      when "500"
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
