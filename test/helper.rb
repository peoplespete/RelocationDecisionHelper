

def assert_command_output expected, command
  result = `#{command}`.strip
  assert_equal expected, result
end