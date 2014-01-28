require 'highline/import'

class Location

  def initialize

  end


  def self.add
    name = ask("What is the name of the city or town you wish to add?") { |q| q.default = "none" }
    puts name
  end

end
