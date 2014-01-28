require 'minitest/autorun'
require_relative '../lib/environment'

class LocationTest < MiniTest::Unit::TestCase
  def setup
    Environment.environment = "test"
  end

  def database
    Environment.database_connection
  end

  def teardown
    database.execute("delete from locations")

  end

  def assert_command_output expected, command
    actual = `#{command} --environment test`.strip
    assert_equal expected, actual
  end

  def assert_in_output output, *args
    missing_content = []
    args.each do |argument|
      unless output.include?(argument)
        missing_content << argument
      end
    end
    assert missing_content.empty?, "Output didn't include #{missing_content.join(", ")}:\n #{output}"
  end

  def assert_not_in_output output, *args
    args.each do |argument|
      assert !output.include?(argument), "Output shouldn't include #{argument}: #{output}"
    end
  end

  def strip_control_characters_and_excesses(string)
    last =  string.split("\033[2;0f").last#.gsub(/(\e\[\d+\w)|(\e\[\w)/,"")
    if last.empty?
      ""
    else
      last.gsub(/(\e\[\d+\w)|(\e\[\w)/,"").gsub(" +","")
    end
  end

  def assert_includes_in_order input, *items
    input = strip_control_characters_and_excesses(input)
    regexp_string = items.join(".*").gsub("?","\\?")
    assert_match /#{regexp_string}/, input.delete("\n"), "Expected /#{regexp_string}/ to match:\n" + input
  end

  def pipe_it(args)
    shell_output = ""
    IO.popen('./relocator test', 'r+') do |pipe|
      args.each do |arg|
        pipe.puts arg
      end
      # pipe.puts
      pipe.close_write
      shell_output = pipe.read
    end
    shell_output
  end

end










