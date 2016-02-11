require "traction/web_connection"

module Traction
  class << self

    def configure(password, web_connections={})
      @password = password
      @web_connections = web_connections
      init_connections
    end

   private

    def init_connections
      @web_connections.each do |name, path|
        self.class.send(:define_method, name, Proc.new{ WebConnection.new(path, @password) })
      end
    end

  end
end
