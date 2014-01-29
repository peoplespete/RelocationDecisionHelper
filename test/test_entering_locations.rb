require_relative 'helper'


class TestEnteringLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs = ['1','Wilmington','DE','2']

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

  def test_valid_purchase_gets_saved
  # @@sample_inputs = ['1','Wilmington','DE','2']
    # `./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test`
    actual = pipe_it @@sample_inputs
    database.results_as_hash = false
    results = database.execute("select * from locations")
    expected = ['Wilmington', 'DE', 'Temperate']
    results[0].shift
    assert_equal expected, results[0]

    result = database.execute("select count(id) from locations")
    assert_equal 1, result[0][0]
  end

  def test_invalid_purchase_doesnt_get_saved
    skip
    `./grocerytracker add Cheerios --calories 210`
    result = database.execute("select count(id) from purchases")
    assert_equal 0, result[0][0]
  end


  # def test_valid_purchase_gets_saved
  #   skip

  #   assert true, "Valid Purchase Saved"
  # end

  # def test_invalid_purchase_doesnt_get_saved
  #   skip "needs to be done"
  #   assert false, "Invalid Purchase Not Saved"
  # end

  # def test_error_message_for_missing_calories
  #   skip
  #   command = './relocator add "Campbells Chicken Soup"'
  #   expected = "You must provide the caloric value of the product"
  #   assert_command_output expected, command

  # end

  # def test_error_message_for_missing_name
  #   skip
  #   command = './relocator add'
  #   expected = "You must provide the name of the product"
  #   assert_command_output expected, command #expected , actual
  # end

end




  # def test_16month_is_output_first_two_lines
  #   shell_output = ""
  #   IO.popen('ruby cal.rb 1 2012', 'r+') do |pipe|
  #     pipe.close_write
  #     shell_output = pipe.read
  #   end
  #   assert_includes_in_order shell_output, "    January 2012    ", "Su Mo Tu We Th Fr Sa"
  # end





