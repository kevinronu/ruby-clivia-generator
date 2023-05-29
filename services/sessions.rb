require "httparty"
require "json"

module Services
  class Sessions
    include HTTParty

    base_uri "https://opentdb.com/api"

    def self.retrieve_session_token
      response = get("_token.php?command=request")

      raise HTTParty::ResponseError, response unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def self.using_session_token(token)
      response = get(".php?amount=10&token=#{token}")

      raise HTTParty::ResponseError, response unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def self.reset_session_token(token)
      response = get("_token.php?command=reset&token=#{token}")

      raise HTTParty::ResponseError, response unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
