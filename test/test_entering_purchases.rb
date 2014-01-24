require 'minitest/autorun'
require_relative 'helper'


class TestEnteringPurchases < MiniTest::Unit::TestCase

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  def test_valid_purchase_gets_saved
    assert false, "Valid Purchase Saved"
  end

  def test_invalid_purchase_doesnt_get_saved
    skip "needs to be done"
    assert false, "Invalid Purchase Not Saved"
  end

  def test_error_message_for_missing_calories
    command = './relocator add "Campbells Chicken Soup"'
    expected = "You must provide the caloric value of the product"
    assert_command_output expected, command

  end

  def test_error_message_for_missing_name
    command = './relocator add'
    expected = "You must provide the name of the product"
    assert_command_output expected, command #expected , actual
  end





  # def test_16month_is_output_first_two_lines
  #   shell_output = ""
  #   IO.popen('ruby cal.rb 1 2012', 'r+') do |pipe|
  #     pipe.close_write
  #     shell_output = pipe.read
  #   end
  #   assert_includes_in_order shell_output, "    January 2012    ", "Su Mo Tu We Th Fr Sa"
  # end




end

