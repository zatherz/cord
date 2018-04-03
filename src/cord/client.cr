require "./discord/gateway"

module Cord
  CONNECTION_PROPERTIES = GatewayConnectionProperties.new(
    {% if flag?(:linux) %}
      os: "linux",
    {% elsif flag?(:win) %}
      os: "windows",
    {% elsif flag?(:darwin) %}
      os: "mac",
    {% else %}
      os: "unknown",
    {% end %}
    browser: "cord",
    device: "cord"
  )

  

  abstract class Client
    getter token : String
    @rest : REST
  end

  class Bot < Client
    def initialize(token : String)
      if token.starts_with? "Bot"
        @token = token
      else
        @token = "Bot #{token}"
      end
    end
  end
end
