require_relative 'helper'


class TestEnteringLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs = ['1','Wilmington','DE','2','5']

  def test_asks_for_name_of_location
    actual = pipe_it @@sample_inputs
    expected = "What is the name of the city or town you wish to add?"
    assert_includes_in_order actual, expected
  end

  def test_asks_for_state_of_location
    actual = pipe_it @@sample_inputs
    expected = "What state is Wilmington in?"
    assert_includes_in_order actual, expected
  end

  def test_asks_for_climate_of_location
    actual = pipe_it @@sample_inputs
    expected = "What climate does Wilmington have?"
    assert_includes_in_order actual, expected
  end

  def test_valid_location_gets_saved
    actual = pipe_it @@sample_inputs
    database.results_as_hash = false
    results = database.execute("select * from locations")
    expected = ['Wilmington', 'DE', 'Temperate']
    results[0].shift
    assert_equal expected, results[0]

    result = database.execute("select count(id) from locations")
    assert_equal 1, result[0][0]
  end

  def test_that_you_cannot_enter_a_city_state_pair_that_already_exists
    #it should pump you into the edit of the existing entry
    actual = pipe_it @@sample_inputs
    result = pipe_it @@sample_inputs
    assert_includes_in_order result, "Sorry, that location already exists."

  end


end







