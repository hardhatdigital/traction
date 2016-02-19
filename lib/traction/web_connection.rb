require "json"
require "net/http"

module Traction

  ##
  # Creates a new WebConnection object to contain wrapped API methods associated with a particular
  # WebConnection, or Function, in Traction API terminology.
  #
  # Method examples use the hypothetical namespaces from the configuration example.
  class WebConnection
    DOMAIN = "int.api.tractionplatform.com"

    def initialize(path, password)
      @path = path
      @password = password
    end

    ##
    # Registration method for retrieving attributes for a customer, searching against a given field.
    #
    # @param field      [String] The field to search against.
    # @param value      [String] The value to search for.
    # @param attributes [Array]  The retrieved customer fields on a successful result.
    #
    # @example
    #           Traction.registration.get_customer_by("EMAIL", "example@email.com", ["EMAIL", "MOBILE", "FIRSTNAME", "LASTNAME"]
    #           #=>
    #           {
    #             data: {
    #               customer: {
    #                 email: "example@email.com",
    #                 mobile: "0412345678",
    #                 firstname: "John",
    #                 lastname: "Doe"
    #               }
    #             },
    #             success: true
    #           }
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 1010,
    #               description: "Customer not found",
    #               cause: [{
    #                 "field": "customer.EMAIL"
    #               }]
    #             }
    #           }
    def get_customer_by(field, value, attributes=[])
      body = {customerLookup: {field => value},
              customerAttributes: attributes}

      get_response_for(body)
    end

    ##
    # Registration method for adding a customer to the campaign customer list.
    #
    # @param details       [Hash] The customer details to add.
    # @param optional_data [Hash] Optional. Data available in triggered emails to the customer.
    #
    # @example
    #           Traction.registration.add_customer("EMAIL" => "example@email.com", "MOBILE" => "0412345678", "FIRSTNAME" => "John", "LASTNAME" => "Doe")
    #           #=> {data: {}, success: true}
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 1000,
    #               description: "Invalid Parameter Data",
    #               cause: [{
    #                 field: "customer.EMAIL",
    #                 message: "invalid email address"
    #               }]
    #             },
    #             success: false
    #           }
    def add_customer(details, optional_data={})
      body = {customer: details,
              transData: optional_data}

      get_response_for(body)
    end

    ##
    # Registration method for adding a customer to the campaign customer list, and associating the customer
    # with (or dissociating a customer from) groups and/or subscriptions.
    #
    # @param details       [Hash] The customer details to add.
    # @param groups        [Hash] Optional. Groups to associate or dissociate with; true associates, false dissociates.
    # @param subscriptions [Hash] Optional. Subscriptions to associate or dissociate with; "SUBSCRIBE" associates, "UNSUBSCRIBE" dissociates.
    #
    # @example
    #           Traction.registration.add_customer_with_group_and_subscription({"EMAIL" => "example@email.com", "MOBILE" => "0412345678", "FIRSTNAME" => "John", "LASTNAME" => "Doe"}, {"12345" => true, "12346" => true, "23456" => false}, {"9876543210" => "SUBSCRIBE", "9876543211" => "SUBSCRIBE", "9876543212" => "UNSUBSCRIBE"})
    #           #=> {data: {}, success: true}
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 1150,
    #               description: "Invalid Group ID, please confirm group exists",
    #               cause: "Group Id [12345] should be pre-existing"
    #             },
    #             success: false
    #           }
    def add_customer_with_group_and_subscription(details, groups={}, subscriptions={})
      body = {customer: details,
              groups: groups,
              subscriptions: subscriptions}

      get_response_for(body)
    end

    ##
    # Registration method for adding a customer directly to an associated email list, selected on creation
    # of the function in traction.
    #
    # @param details       [Hash] The customer details to add.
    # @param optional_data [Hash] Optional. Data available in triggered emails to the customer.
    #
    # @example
    #           Traction.registration.add_customer("EMAIL" => "example@email.com", "MOBILE" => "0412345678", "FIRSTNAME" => "John", "LASTNAME" => "Doe")
    #           #=> {data: {}, success: true}
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 1000,
    #               description: "Invalid Parameter Data",
    #               cause: [{
    #                 field: "customer.EMAIL",
    #                 message: "invalid email address"
    #               }]
    #             },
    #             success: false
    #           }
    def web_registration(details, optional_data={})
      body = {customer: details,
              transData: optional_data}

      get_response_for(body)
    end

    ##
    # Competition method for validating a potential entry to a competition.
    #
    # @param field      [String] The relevant customer field to validate with.
    # @param value      [String] The value associated with the field.
    # @param entry_code [String] The entry code to validate.
    #
    # @example
    #           Traction.competition.validate_entry("EMAIL", "example@email.com", "ABC123")
    #           #=> {data: {}, success: true}
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 2040,
    #               description: "Entry Code Used",
    #               cause: [{
    #                 field: "entryCode",
    #                 message: "[ABC123]  has already been used"
    #               }]
    #             },
    #             success: false
    #           }
    def validate_entry(field, value, entry_code)
      body = {mode: "VALIDATE",
              customer: {field => value},
              entryCode: entry_code}
       
      get_response_for(body)
    end

    ##
    # Competition method for adding an entrant to (or removing an entrant from) a competition.
    #
    # @param details       [Hash]    The customer details to add.
    # @param entry_code    [String]  The entry code for the entrant.
    # @param subscribe     [Boolean] Optional. Subscribe (true) or unsubscribe (false) from the competition. Defaults to true.
    # @param optional_data [Hash]    Optional. Data available in triggered emails to the customer.
    #
    # @example
    #           Traction.competition.add_competition_entrant({"EMAIL" => "example@email.com", "MOBILE" => "0412345678", "FIRSTNAME" => "Jane", "LASTNAME" => "Doe"}, "XYZ123")
    #           #=> {data: {}, success: true}
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 2040,
    #               description: "Entry Code Used",
    #               cause: [{
    #                 field: "entryCode",
    #                 message: "[XYZ123]  has already been used"
    #               }]
    #             },
    #             success: false
    #           }
    def add_competition_entrant(details, entry_code, subscribe=true, optional_data={})
      body = {customer: details,
              entryCode: entry_code,
              subscribe: subscribe,
              transData: optional_data}
       
      get_response_for(body)
    end

    ##
    # Competition method for drawing the competition winner/s.
    #
    # @param venues_ids [Array] Optional. List of venues for which the winner is drawn from. Defaults to all venues.
    #
    # @example
    #           Traction.competition.draw
    #           #=> {data: {}, success: true}
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 2140,
    #               description: "Draw already done",
    #               cause: null
    #             },
    #             success: false
    #           }
    def draw_competition(venue_ids=[])
      body = {mode: "DRAW"}
      body[:venueIdList] = venue_ids if venue_ids.any?

      get_response_for(body)
    end

    ##
    # Competition method for providing redemption code to a winner.
    #
    # @param field           [String] The field to search against.
    # @param value           [String] The value to search for.
    # @param venues_id       [String] Id of venue for which redemption code and customer apply.
    # @param redemption_code [String] The redemption code for the winner.
    # @param optional_data   [Hash]   Optional. Data available in triggered emails to the customer.
    #
    # @example
    #           Traction.competition.redeem_winner("EMAIL", "example@email.com", "XYZ", "ABC123") 
    #           #=>
    #           {
    #             data: {
    #               numWinners: 8,
    #               numWinnersNoRedemptionCode: 2
    #             },
    #             success: true
    #           }
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 2120,
    #               description: "Claim code invalid",
    #               cause: null
    #             },
    #             success: false
    #           }
    def redeem_winner(field, value, venue_id, redemption_code, optional_data={})
      body = {mode: "REDEEM",
              customer: {field => value},
              venueId: venue_id,
              redemptionCode: redemption_code,
              transData: optional_data}

      get_response_for(body)
    end

    ##
    # Triggered Message method for sending a triggered email to a subscriber. The content of the email
    # can be personalised with optional data, but should already exist in traction.
    #
    # @param email         [String] The email to search against.
    # @param optional_data [Hash]   Optional. Data available in triggered emails to the customer.
    #
    # @example
    #           Traction.triggered.send_triggered_email("example@email.com")
    #           #=> {data: {}, success: true}
    #           # OR
    #           #=>
    #           {
    #             error: {
    #               code: 1000,
    #               description: "Invalid Parameter Data",
    #               cause: [{
    #                 field: "customer.Email",
    #                 message: "Invalid Email Address"
    #               }]
    #             },
    #             success: false
    #           }
    def send_triggered_email(email, optional_data={})
      body = {customer: {EMAIL: email},
              transData: optional_data}

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
