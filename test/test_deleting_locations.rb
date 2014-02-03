require_relative 'helper'


class TestDeletingLocations < LocationTest

  @@sample_inputs_write_ = ['1','Wilmington','DE','2','5']
  @@sample_inputs_write_2 = ['1','Easton','pa','1','5']
  @@sample_inputs_delete = ['4','1','5']
  @@sample_inputs_delete_2 = ['4','3','5']

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  def test_removing_all_locations
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    database.results_as_hash = false
    Location.remove(nil)
    result = database.execute("select count(id) from locations")
    assert_equal 0, result[0][0]
  end

  def test_removing_chosen_location
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    database.results_as_hash = false
    Location.remove(['Easton', 'PA'])
    result = database.execute("select * from locations")
    result = clean_db_output(result)
    assert_equal result, ['Wilmington', 'DE', 'Temperate']
  end

  def test_removing_displays_message_confirming_removal
    pipe_it @@sample_inputs_write_
    pipe_it @@sample_inputs_write_2
    database.results_as_hash = false
    result = pipe_it @@sample_inputs_delete
    assert_includes_in_order result, 'Location Removed'
  end

  def test_removing_displays_message_confirming_removal_of_all
    pipe_it @@sample_inputs_write_
    pipe_it @@sample_inputs_write_2
    database.results_as_hash = false
    result = pipe_it @@sample_inputs_delete_2
    assert_includes_in_order result, 'Locations Removed'
  end



end







