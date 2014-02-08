require_relative 'helper'


class TestDeletingLocations < LocationTest

  @@sample_inputs_write_ = ['1','Wilmington','DE','2','no jobs','77','my wife loves it','5']
  @@sample_inputs_write_2 = ['1','Easton','pa','1','no jobs','77','my wife loves it','5']
  @@sample_inputs_delete = ['4','1','5']
  @@sample_inputs_delete_2 = ['4','3','5']

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  def test_removing_all_locations
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    Location.remove(nil)
    # result = database.execute("select count(id) from locations")
    assert_equal 0, Location.count
  end

  def test_removing_chosen_location
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    location = Location.first
    Location.remove(location)
    location = Location.first
    result = [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    # result = database.execute("select * from locations")
    # result = clean_db_output(result)
    assert_equal result, ['Wilmington', 'DE', 'Temperate','no jobs',77,'my wife loves it']
  end

  def test_removing_displays_message_confirming_removal
    pipe_it @@sample_inputs_write_
    pipe_it @@sample_inputs_write_2
    result = pipe_it @@sample_inputs_delete
    assert_includes_in_order result, 'Location Removed'
  end

  def test_removing_displays_message_confirming_removal_of_all
    pipe_it @@sample_inputs_write_
    pipe_it @@sample_inputs_write_2
    result = pipe_it @@sample_inputs_delete_2
    assert_includes_in_order result, 'Locations Removed'
  end
end







