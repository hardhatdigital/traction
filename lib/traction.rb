require "traction/web_connection"

class Traction

  def initialize(password)
    @password = password
  end

  def web_connection(path)
    Traction::WebConnection.new(path, @password)
  end

end
