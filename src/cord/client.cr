module Cord
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
