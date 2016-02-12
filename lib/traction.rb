require "traction/web_connection"

##
# The Traction module houses methods to interact with the Traction API.
module Traction

  ##
  # Configure Traction with your API password and an object containing keys that are namespaces
  # that you elect, and paths associated with a "web connection" available to you in your Traction account.
  # These paths are found in "API Information" in the Traction Account Dashboard.
  #
  # An ArgumentErorr is raised if you attempt to create a web connection name using a reserved word.
  #
  # @param password       [String] Your API password. You might want to keep this a secret.
  # @param web_connection_paths [Hash]   The namespaces and paths for each 
  #
  # @example
  #           Traction.configure("<your_api_password>", { competition: "",
  #                                                       registration: "" }
  def self.configure(password, web_connection_paths={})
    web_connection_paths.each do |name, path|
      raise ArgumentError, "!ERROR: Unable to define a web_connection_paths path with name: #{name} as this is a reserved name." if self.class.respond_to?(name)
      self.class.send(:define_method, name, -> { WebConnection.new(path, password) })
    end
  end

end
