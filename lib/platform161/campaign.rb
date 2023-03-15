require "./lib/platform161/resource"

module Platform161

  class Campaign < Resource

    END_POINT = "campaigns"

    def initialize(instance = nil)
      super(END_POINT, instance)
    end

    def active
      @api.filter(:active, "true")
      self
    end
  end

end