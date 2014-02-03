require_relative 'helper'


class TestDeletingLocations < LocationTest

  @@sample_inputs_write_ = ['1','Wilmington','DE','2','5']
  @@sample_inputs_write_2 = ['1','Easton','pa','1','5']

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




  def test_integration_test_delete
    skip


  end

end







