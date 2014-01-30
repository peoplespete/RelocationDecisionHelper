require_relative 'helper'


class TestReadingLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs_write_ = ['1','Wilmington','DE','2']
  @@sample_inputs_write_2 = ['1','Easton','pa','1']
  @@sample_inputs_read_ = ['2','2']

  def test_that_you_can_retrieve_all_locations
    # skip
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    database.results_as_hash = false
    result = Location.find(nil)
    result = result.map do |entry|
      entry.shift
      return entry
    end
    expected = [['Wilmington', 'DE', 'Temperate'],['Easton','PA','Cool']]
    assert_equal expected, results
  end

  def test_that_you_can_retrieve_a_location_by_city
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    database.results_as_hash = false
    result = Location.find(["Wilmington","DE"])
    result = result.map do |entry|
      entry.shift
      return entry
    end
    expected = ['Wilmington', 'DE', 'Temperate']
    assert_equal expected, result
  end

  def test_that_user_is_asked_for_city_search_term
    actual1 = pipe_it @@sample_inputs_write_
    actual2 = pipe_it @@sample_inputs_write_2
    actual = pipe_it @@sample_inputs_read_
    expected = "What city would you like to view?"
    assert_includes_in_order actual, expected
  end


# def test_list_returns_relevant_results
#     # create will be new+save
#     cheerios = Purchase.create(name: "Cheerios", calories: 210, price: 1.55)
#     corn_flakes = Purchase.create(name: "Corn Flakes", calories: 110, price: 5.50)
#     corn_bran = Purchase.create(name: "Corn Bran", calories: 510, price: 1.50)

#     command = "./grocerytracker list"
#     expected = <<EOS.chomp
# All Purchases:
# Cheerios: 210 calories, $1.55, id: #{cheerios.id}
# Corn Bran: 510 calories, $1.50, id: #{corn_bran.id}
# Corn Flakes: 110 calories, $5.50, id: #{corn_flakes.id}
# EOS
#     assert_command_output expected, command
#   end




end