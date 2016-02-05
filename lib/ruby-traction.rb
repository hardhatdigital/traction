require "ruby-traction/web_connection"

class RubyTraction

  def initialize(password)
    @password = password
  end

  def web_connection(path)
    RubyTraction::WebConnection.new(path, @password)
  end

end
