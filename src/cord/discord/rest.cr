require "../version"
require "http/client"
require "openssl/ssl/context"

class Cord::Discord::REST
  @mutexes : Hash(RateLimitKey, Mutex)? = nil
  @global_mutex : Mutex? = nil
  @token : String

  SSL_CONTEXT = OpenSSL::SSL::Context::Client.new
  USER_AGENT  = "DiscordBot (https://github.com/zatherz/cord, #{VERSION})"
  API_BASE    = "https://discordapp.com/api/v6"

  alias RateLimitKey = {route_key: Symbol, major_param: UInt64?}

  def initialize(@token)
  end

  def raw_request(route_key : Symbol, major_param : UInt64?, method : String, path : String, body : String? = nil, headers = HTTP::Headers.new)
    mutexes = (@mutexes ||= {} of RateLimitKey => Mutex)
    global_mutex = (@global_mutex ||= Mutex.new)

    headers["Authorization"] = @token
    headers["User-Agent"] = USER_AGENT

    request_done = false
    rl_key = {route_key: route_key, major_param: major_param}

    response : HTTP::Client::Response?

    until request_done
      mutexes[rl_key] ||= Mutex.new

      mutexes[rl_key].synchronize { }
      global_mutex.synchronize { }

      response = HTTP::Client.exec method, url: "#{API_BASE}#{path}", headers: headers, body: body, tls: SSL_CONTEXT

      if response.status_code == 429 || response.headers["X-RateLimit-Remaining"]? == "0"
        retry_after : Float64 | Time::Span

        if response.headers["Retry-After"]?
          retry_after = response.headers["Retry-After"].to_i / 1000.0
        else
          origin_time = HTTP.parse_time(response.headers["Date"]).not_nil!
          reset_time = Time.epoch response.headers["X-RateLimit-Reset"].to_u64
          retry_after = reset_time - origin_time
        end

        if response.headers["X-RateLimit-Global"]?
          global_mutex.synchronize { sleep retry_after }
        else
          mutexes[rl_key].synchronize { sleep retry_after }
        end

        request_done = true unless response.status_code == 429
      else
        request_done = true
      end
    end

    response.as(HTTP::Client::Response)
  end

  class HTTPException < Exception
    getter response : HTTP::Client::Response

    def initialize(@response)
      super "HTTP result #{@response.status_code}"
    end

    def status_code
      @response.status_code
    end
  end

  class DetailedException < Exception
    getter response : HTTP::Client::Response
    @payload : RESTError

    def initialize(@response)
      @payload = RESTError.from_json @response.body
      super @payload.message
    end

    def status_code
      @response.status_code
    end

    def error_code
      @payload.code
    end
  end

  def request(route_key : Symbol, major_param : UInt64?, method : String, path : String, body : String? = nil, headers = HTTP::Headers.new)
    response = raw_request route_key, major_param, method, path, body, headers

    if !response.success?
      if response.content_type != "application/json"
        raise HTTPException.new response

        begin
          raise DetailedException.new response
        rescue
          raise HTTPException.new response
        end
      end
    end

    response
  end
end
