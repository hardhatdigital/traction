require "traction/web_connection"

##
# The Traction module houses methods to interact with the Traction API.
module Traction

  ##
  # Configure Traction with your API password and an object containing keys that become namespaces
  # and paths associated with a "web connection" available to you in your Traction account.
  # These paths are found in "API Information" in the Traction Account Dashboard, for a function
  # within a given campaign.
  #
  # An ArgumentError is raised if you attempt to create a web connection name using a reserved word.
  #
  # The below example generates the namespaces Traction.competition and Traction.registration for
  # functions available in the traction dashboard. The methods available to these namespaces will
  # depend on the functions that were created in the traction dashboard.
  #
  # @param password             [String] Your API password. You might want to keep this a secret.
  # @param web_connection_paths [Hash]   The namespaces and paths for each "function" eg. "/wkf/81h2ehc781hjd"
  #
  # @example
  #           Traction.configure("<your_api_password>", {competition:  "<web_connection_path>",
  #                                                      registration: "<web_connection_path>",
  #                                                      triggered:    "<web_connection_path>"}
  def self.configure(password, web_connection_paths={})
    web_connection_paths.each do |name, path|
      raise ArgumentError, "!ERROR: Unable to define a web_connection_paths path with name: #{name} as this is a reserved name." if self.class.respond_to?(name)
      self.class.send(:define_method, name, -> { WebConnection.new(path, password) })
    end
  end

end
