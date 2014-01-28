require 'highline/import'

class Location

  def initialize

  end


  def self.add
    location_options = {}
    location_options[:name] = ask("What is the name of the city or town you wish to add?") { |q| q.default = "none" }
    location_options[:state_code] = ask("What state is #{location_options[:name]} in?") { |q| q.default = "none" }


  end

end
