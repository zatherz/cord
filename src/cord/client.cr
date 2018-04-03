require "./discord/gateway"
require "./discord/rest"

module Cord
  {% begin %}
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
  {% end %}

  class Bot
    getter token : String

    def initialize(token : String)
      if token.starts_with? "Bot"
        @token = token
      else
        @token = "Bot #{token}"
      end
    end
  end
end
