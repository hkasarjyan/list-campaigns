require "./lib/platform161/campaign"

data 			= []
instance        = "sandboxcost"
campaign_fields = ["name", "start_on", "end_on", "active", "advertiser"]
campaign_filter = [
	{
		key: :start_on,
		value: "2022-01-01",
		match_key: Platform161::Api::Api::FILTER_GREATER
	},
	{
		key: :status,
		value: "active",
		match_key: Platform161::Api::Api::FILTER_NOT_EQUAL
	}
]

campaign_api = Platform161::Campaign.new(instance)
campaign_api.fields(campaign_fields).get(nil, campaign_filter).each do |campaign|
	advertiser_id = campaign["relationships"]["advertiser"]["data"]["id"]

	campaign_data = {}
	campaign_data[:advertiser]  = campaign["relationships"]["advertiser"]["data"]["id"]
	campaign_data[:name]        = campaign["attributes"]["name"]
	campaign_data[:start]       = campaign["attributes"]["start_on"][0, 10]
	campaign_data[:end]         = campaign["attributes"]["end_on"][0, 10]
	campaign_data[:active] 		= campaign["attributes"]["active"]

	data << campaign_data
end

puts data