require "traction/web_connection"

module Traction
  def self.configure(password, function_paths={})
    function_paths.each do |name, path|
      raise ArgumentError, "!ERROR: Unable to define a function path with name: #{name} as this is a reserved name." if self.class.respond_to?(name)
      self.class.send(:define_method, name, -> { WebConnection.new(path, password) })
    end
  end
end
