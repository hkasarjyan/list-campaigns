require 'httparty'

module Platform161

  module Api

    class Client

        REQUIRED_KEYS = [:login, :password]
        TOKEN_TTL     = 0.9 * 60 * 60
        TIMEOUT       = 300

        def initialize(credentials, api_url, endpoint, instance)
          unknown_keys = credentials.keys - REQUIRED_KEYS.flatten
          raise ArgumentError, "Unknown key(s): #{unknown_keys.join(", ")}" unless unknown_keys.empty?

          @credentials       = credentials
          @api_url           = api_url
          @endpoint          = endpoint
          @instance          = instance
          @token             = nil
          @token_expires_at  = nil
        end

        def request(method, resource, id = nil, parameters = {}, relationship = nil)
          uri    = "#{build_base_url}/#{resource}"
          uri    = "#{uri}/#{id}" unless id.nil?
          uri    = "#{uri}/relationships/#{relationship}" unless relationship.nil?
          header = {
            "Authorization: Bearer " => token,
            "Content-Type"           => "application/json",
            "Accept"                 => "application/json"
          }
          
          HTTParty.public_send(method, uri, body: parameters.to_json, headers: header, timeout: TIMEOUT)
        end

        private

          def token
            if @token.nil? || (Time.now.to_i >= @token_expires_at.to_i)
              uri         = "#{build_base_url}/tokens"
              credentials = { "user" => @credentials }
              response    = HTTParty.public_send('post', uri, body: credentials)

              @token            = response['access_token']
              @token_expires_at = Time.now + TOKEN_TTL
            end

            @token
          end

          def build_base_url
            "#{@api_url}/#{@endpoint}/#{@instance}"
          end
    end
  end
end