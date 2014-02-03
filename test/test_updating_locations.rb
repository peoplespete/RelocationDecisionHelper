require_relative 'helper'


class TestUpdatingLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs_write = ['1','Eston','pa','1','no jobs','77','my wife loves it','5']
  @@sample_inputs_update = ['3','1','Easton','MA','Temperate','jobs yes!','53','ewww like totally!','5']

  def test_update_allows_user_to_change_existing_information
    pipe_it @@sample_inputs_write
    database.results_as_hash = false
    Location.update(['Eston', 'PA', 'Cool','no jobs','77','my wife loves it'],['Easton','MA', 'Temperate','jobs yes!','53','ewww like totally!'])
    result = database.execute("select * from locations")
    result = clean_db_output(result)
    assert_equal result, ['Easton','MA', 'Temperate','jobs yes!',53,'ewww like totally!']
  end

  def test_update_works_with_highline_prompts
    pipe_it @@sample_inputs_write
    database.results_as_hash = false
    pipe_it @@sample_inputs_update
    result = database.execute("select * from locations")
    result = result.flatten.drop(1)
    assert_equal result, ['Easton','MA', 'Temperate','jobs yes!',53,'ewww like totally!']
  end

  def test_update_displays_message_confirming_update
    pipe_it @@sample_inputs_write
    database.results_as_hash = false
    result = pipe_it @@sample_inputs_update
    # result = clean_db_output(result)
    assert_includes_in_order result, 'Location Updated'
  end

end