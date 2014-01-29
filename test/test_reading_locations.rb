require_relative 'helper'


class TestReadingLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs = ['1','Wilmington','DE','2']
  @@sample_inputs2 = ['1','Easton','pa','1']

  def test_that_you_can_retrieve_all_locations
    # can i make the process of adding locations more unity like Locations.new
    # rather then the way i have it which is pretty integrationy
    actual1 = pipe_it @@sample_inputs
    actual2 = pipe_it @@sample_inputs2
    database.results_as_hash = false
    result = database.execute("select * from locations")
    result = result.map do |entry|
      entry.shift
      return entry
    end
    expected = [['Wilmington', 'DE', 'Temperate'],['Easton','PA','Cool']]

    assert_equal expected, actual

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