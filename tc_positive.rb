require "test/unit"
require 'date'
require_relative 'list_campaigns.rb'


class TestListCampaigns < Test::Unit::TestCase

  puts $data[0][:active]
  #puts $data[0][:start]
  def test_inactive
    data_length = $data.length
    for i in 0..data_length-1
      assert_equal($data[i][:active], false, "Campaign is still active")
    end
  end


  def test_start_date
    data_length = $data.length
    for i in 0..data_length-1
      start_date =  DateTime.parse($data[i][:start])
      compare_date = DateTime.parse("2022-01-01")
      assert(start_date>compare_date, "Start date is not correct" )
    end
  end


end


