require "yaml"
require "active_support/inflector"
require_relative "client"

module Platform161

  module Api

    class Api
      attr_reader :resource
      attr_reader :resource_type
      attr_reader :parameters

      FILTER_EQUAL         = "eq"
      FILTER_NOT_EQUAL     = "ne"
      FILTER_LESS          = "lt"
      FILTER_LESS_EQUAL    = "le"
      FILTER_GREATER       = "gt"
      FILTER_GREATER_EQUAL = "ge"
      FILTER_LIKE          = "like"
      FILTER_IN            = "in"
      FILTER_NOT_IN        = "not_in"
      FILTER_NULL          = "is_null"
      FILTER_NOT_NULL      = "is_not_null"

      def initialize(instance = nil)
        @config = YAML.load_file("./config/platform161.yml")

        credentials = {
          login:    @config[:api][:login],
          password: @config[:api][:password]
        }

        hostname            = @config[:api][:hostname]
        endpoint            = @config[:api][:endpoint]
        client_destination  = if instance.nil?
          @config[:api][:default_instance]
        else
          instance
        end

        @client = Platform161::Api::Client.new(credentials, hostname, endpoint, client_destination)

        reset
      end

      def resource(resource)
        @resource = resource
        self
      end

      def reset
        @parameters = {}
        self
      end

      def add_parameter(key, value)
        @parameters[key] = value unless value.empty?
        self
      end

      def filter(key, value, match_key = FILTER_EQUAL)
        @parameters[:filter] ||= {__and: {}}
        @parameters[:filter][:__and][key.to_sym] = {match_key.to_sym => value}
      end

      def create(id = nil, relationship = nil)
        request(:post, @resource, id, get_parameters_json_api, relationship)
      end

      def read(id = nil, relationship = nil)
         request(:get, @resource, id, @parameters, relationship)
      end

      def list_resource
        data         = []
        current_page = 1

        loop do
          response_data = request(:get, @resource, nil, @parameters.merge({page: {number: current_page}}))

          break if response_data["errors"]
          data.concat(response_data["data"]) if response_data["data"]

          current_page = response_data["meta"]["next_page"]

          break if current_page.nil?
        end

        data
      end

      private

        def get_parameters_json_api
          data = {
            data: {
              type: @resource.singularize,
              attributes: @parameters
            }
          }
          data
        end

        def request(verb, resource, id, parameters = {}, relationship = nil)
          response = @client.request(verb, resource, id, parameters, relationship)

          raise Exception, response.code unless [200, 201, 202, 401].include?(response.code)

          response
        end

    end

  end
end