require "active_support/inflector"
require "./lib/platform161/api/api"

module Platform161

  class Resource

    END_POINT = ""

    def initialize(end_point, instance = nil, options = {})
      @api = Platform161::Api::Api.new(instance)
      @api.resource(end_point)
    end

    def fields(field_list, resource = nil)
      resource = self.class::END_POINT.singularize if resource.nil?

      @api.add_parameter(:fields, {resource => field_list.join(",")})
      self
    end

    def get(id = nil, filters = [])
      if id
        @api.read(id)
      else
        filters.each{|filter| @api.filter(filter[:key], filter[:value], filter[:match_key])}
        response = @api.list_resource
        reset_filter
        response
      end
    end

    def reset_filter
      @api.reset
    end

  end

end