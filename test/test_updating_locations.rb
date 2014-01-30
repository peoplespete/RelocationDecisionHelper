require_relative 'helper'


class TestUpdatingLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs_write = ['1','Eston','pa','1']
  @@sample_inputs_update = ['3','1','Easton','MA','Temperate']

  def test_update_allows_user_to_change_existing_information
    pipe_it @@sample_inputs_write
    database.results_as_hash = false
    Location.update(['Eston', 'PA', 'Cool'],['Easton','MA', 'Temperate'])
    result = database.execute("select * from locations")
    result = clean_db_output(result)
    assert_equal result, ['Easton','MA', 'Temperate']
  end

  def test_update_works_with_highline_prompts
    pipe_it @@sample_inputs_write
    database.results_as_hash = false
    pipe_it @@sample_inputs_update
    result = database.execute("select * from locations")
    result = result.flatten.drop(1)
    # result = clean_db_output(result)
    assert_equal result, ['Easton','MA', 'Temperate']

  end

end