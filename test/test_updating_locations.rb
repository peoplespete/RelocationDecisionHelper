require_relative 'helper'


class TestUpdatingLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs_write = ['1','Eston','pa','1','no jobs','77','my wife loves it','5']
  @@sample_inputs_update = ['3','1','Easton','MA','Temperate','jobs yes!','53','ewww like totally!','5']

  def test_update_allows_user_to_change_existing_information
    pipe_it @@sample_inputs_write
    location = Location.first
    location.update(city: 'Easton'.capitalize, state_code: 'MA'.upcase, climate: 'Temperate'.capitalize, employment_outlook: 'jobs yes!', cost_of_living: 53, notes: 'ewww like totally!')
    # location.update(['Eston', 'PA', 'Cool','no jobs','77','my wife loves it'],['Easton','MA', 'Temperate','jobs yes!','53','ewww like totally!'])
    location = Location.first
    result = [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    # result = database.execute("select * from locations")
    # result = clean_db_output(result)
    assert_equal ['Easton','MA', 'Temperate','jobs yes!',53,'ewww like totally!'], result
  end

  def test_update_works_with_highline_prompts
    pipe_it @@sample_inputs_write
    pipe_it @@sample_inputs_update
    location = Location.first
    # result = database.execute("select * from locations")
    # result = result.flatten.drop(1)
    result = [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    assert_equal result, ['Easton','MA', 'Temperate','jobs yes!',53,'ewww like totally!']
  end

  def test_update_displays_message_confirming_update
    pipe_it @@sample_inputs_write
    result = pipe_it @@sample_inputs_update
    # result = clean_db_output(result)
    assert_includes_in_order result, 'Location Updated'
  end

end