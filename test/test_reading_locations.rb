require_relative 'helper'


class TestReadingLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs_write_ = ['1','Wilmington','DE','2','no jobs','77','my wife loves it','5']
  @@sample_inputs_write_2 = ['1','Easton','pa','1','no jobs','77','my wife loves it','5']
  @@sample_inputs_read_ = ['2','2','2','5']

  def test_that_you_can_retrieve_all_locations
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    locations = Location.locate(nil)
    result = []
    locations.each do |location|
      result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    end
    expected = [['Easton','PA','Cool','no jobs',77,'my wife loves it'],['Wilmington', 'DE', 'Temperate','no jobs',77,'my wife loves it']]
    assert_equal expected, result
  end

  def test_that_you_can_retrieve_a_location_by_city
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    local = Location.last
    location = Location.locate(local)
    location = location[0]
    result = []
    result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    result.flatten!
    expected = ['Wilmington', 'DE', 'Temperate','no jobs',77,'my wife loves it']
    assert_equal expected, result
  end

  def test_that_user_is_asked_for_city_search_term
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    actual = pipe_it @@sample_inputs_read_
    expected = "What city would you like to view?"
    assert_includes_in_order actual, expected
  end
end