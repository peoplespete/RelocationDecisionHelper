require 'highline/import'
require 'colorize'

$color_dark = :black
$color_light = :light_yellow

class Location < ActiveRecord::Base

  default_scope { order("city ASC") }


  # attr_accessor :name, :state_code, :climate, :employment_outlook, :cost_of_living, :notes
  # def initialize(options)
  #   @name = options[:name].capitalize
  #   @state_code = options[:state_code].upcase
  #   @climate = options[:climate]
  #   @employment_outlook = options[:employment_outlook]
  #   @cost_of_living = options[:cost_of_living].to_i
  #   @notes = options[:notes]
  # end


  def self.locate(search_city = nil)
    # city = search_city ? search_city[0] : nil
    # state_code = search_city ? search_city[1] : nil
    if search_city
      results = Location.where(city: search_city[0], state_code: search_city[1]).limit(1)
    else
      results = Location.all
      # database.execute("select * from locations order by id asc")
    end
    results
  end

  def self.fetch_query(action = nil)
    locations = Location.all
    # database.execute("select city, state_code, climate, employment_outlook, cost_of_living, notes from locations order by id asc")
    choose do |menu|
      menu.prompt = "What city would you like to #{action}?".bold.colorize(:color => $color_dark, :background => $color_light)
      locations.each do |location|
        menu.choice("#{location.city}, #{location.state_code}") do |chosen|
          location
        end
      end
      unless action == 'update'
        all = (action << ' all').upcase
        menu.choice(all) do |chosen|
          nil
        end
      end
    end
  end

  def self.remove(delete_city = nil)
    cities_or_city = locate(delete_city)
    plural = ''
    cities_or_city.each_with_index do |entry, i|
      Location.destroy(entry.id)
        # "delete from locations where id = '#{entry[0]}'")
      plural = 's' if i > 0
    end
    puts "Location#{plural} Removed".bold.colorize(:color => $color_light, :background => $color_dark)
  end


  def self.fetch_replacement(old_data)
    location_attrs = [old_data.city, old_data.state_code, old_data.climate, old_data.employment_outlook, old_data.cost_of_living, old_data.notes]
    options = []
    location_attrs.each do |attr|
      options << ask("The entry is currently: #{attr}.  Type a new value or press ENTER to leave unchanged.".colorize(:color => $color_dark, :background => $color_light)) { |q| q.default = attr }
    end
    location = Location.find(old_data.id)
    location.update(city: options[0].capitalize, state_code: options[1].upcase, climate: options[2].capitalize, employment_outlook: options[3], cost_of_living: options[4].to_i, notes: options[5])
    # location.update(city: 'Easton'.capitalize, state_code: 'MA'.upcase, climate: 'Temperate'.capitalize, employment_outlook: 'jobs yes!', cost_of_living: 53, notes: 'ewww like totally!')
  end

  def self.build_search
    location_options = {}
    puts "Welcome to the search tool!".bold.colorize(:color => $color_dark, :background => $color_light)
    choose do |menu|
      menu.prompt = "Would you like to filter by state?".bold.colorize(:color => $color_dark, :background => $color_light)
      menu.choice("Yes") do |chosen|
        states = ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY","AS","DC","FM","GU","MH","MP","PW","PR","VI","AE","AA","AP"]
        location_options[:state_code] = ask("What state would you like to filter by?".bold.colorize(:color => $color_dark, :background => $color_light)) { |q| q.in = (states << states.map{|state| state.downcase}).flatten }
      end
      menu.choice("No") do |chosen|
      end
    end

    choose do |menu|
      menu.prompt = "Would you like to filter by climate?".bold.colorize(:color => $color_dark, :background => $color_light)
      menu.choice("Yes") do |chosen|
        choose do |menu|
          menu.prompt = "What climate would you like to filter by?".bold.colorize(:color => $color_dark, :background => $color_light)
          menu.choice("Cool") do |chosen|
            location_options[:climate] = 'Cool'
          end
          menu.choice("Temperate") do |chosen|
            location_options[:climate] = 'Temperate'
          end
          menu.choice("Warm") do |chosen|
            location_options[:climate] = 'Warm'
          end
        end
      end
      menu.choice("No") do |chosen|
      end
    end


    choose do |menu|
      menu.prompt = "Would you like to filter by employment outlook?".bold.colorize(:color => $color_dark, :background => $color_light)
      menu.choice("Yes") do |chosen|
        location_options[:employment_outlook] = ask("What employment keyword would you like to filter by?".bold.colorize(:color => $color_dark, :background => $color_light)) {}
      end
      menu.choice("No") do |chosen|
      end
    end

    choose do |menu|
      menu.prompt = "Would you like to filter by cost of living?".bold.colorize(:color => $color_dark, :background => $color_light)
      menu.choice("Yes") do |chosen|
        location_options[:greater_than] = ask("What is the minimum cost of living?".bold.colorize(:color => $color_dark, :background => $color_light), Integer) { |q| q.in = -1..100 }
        location_options[:less_than] = ask("What is the maximum cost of living?".bold.colorize(:color => $color_dark, :background => $color_light), Integer) { |q| q.in = -1..100 }
      end
      menu.choice("No") do |chosen|
      end
    end

    choose do |menu|
      menu.prompt = "Would you like to filter by notes?".bold.colorize(:color => $color_dark, :background => $color_light)
      menu.choice("Yes") do |chosen|
        location_options[:notes] = ask("What notes keyword would you like to filter by?".bold.colorize(:color => $color_dark, :background => $color_light)) {}
      end
      menu.choice("No") do |chosen|
      end
    end
    puts '[ID, CITY, STATE, CLIMATE, EMPLOYMENT OUTLOOK, COST OF LIVING INDEX, NOTES]'.bold.colorize(:color => $color_light, :background => $color_dark)
    search(location_options)
  end

  def self.search(parameters)
    where_string = "where "
    like = ""
    operator = "="

    parameters.each do |key,value|
    operator = case key
      when :state_code
        value.upcase!
        like = ""
        "="
      when :climate, :employment_outlook, :notes
        like = "%"
        "LIKE"
      when :greater_than
        key = :cost_of_living
        like = ""
        ">"
      when :less_than
        key = :cost_of_living
        like = ""
        "<"
      end
      where_string << key.to_s << " #{operator} '#{like}#{value}#{like}' and " #MAKE VALUE STRING
    end
    where_string = where_string[0..-5] #removes the extra 'and' off the end
    results = Location.find_by_sql("select * from locations #{where_string} order by id asc")
    results
  end
end
