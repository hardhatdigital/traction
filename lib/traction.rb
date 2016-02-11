require "traction/web_connection"

module Traction
  def self.configure(password, function_paths={})
    function_paths.each do |name, path|
      self.class.send(:define_method, name, -> { WebConnection.new(path, password) })
    end
  end
end
