require 'minitest/autorun'
require_relative 'helper'

class TestEnteringPurchases < MiniTest::Unit::TestCase

# to run a single line test
# ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  def test_valid_purchase_gets_saved
    assert false, "Valid Purchase Saved"
  end

  def test_invalid_purchase_doesnt_get_saved
    assert false, "Invalid Purchase Not Saved"
  end

  def test_error_message_for_missing_calories
    assert false, ""

  end

  def test_error_message_for_missing_name
    command = './relocator add'
    expected = "You must provide the name of the product"
    assert_command_output expected, command #expected , actual
  end

end

