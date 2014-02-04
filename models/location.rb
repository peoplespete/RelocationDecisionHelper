require 'highline/import'
require 'colorize'

$color_dark = :black
$color_light = :light_yellow

class Location
  attr_accessor :name, :state_code, :climate, :employment_outlook, :cost_of_living, :notes
  def initialize(options)
    @name = options[:name].capitalize
    @state_code = options[:state_code].upcase
    @climate = options[:climate]
    @employment_outlook = options[:employment_outlook]
    @cost_of_living = options[:cost_of_living].to_i
    @notes = options[:notes]
  end


  def self.add
    location_options = {}
    location_options[:name] = ask("What is the name of the city or town you wish to add?".bold.colorize(:color => $color_dark, :background => $color_light)) { |q| q.default = "none" }
    states = ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY","AS","DC","FM","GU","MH","MP","PW","PR","VI","AE","AA","AP"]
    location_options[:state_code] = ask("What state is #{location_options[:name]} in?".bold.colorize(:color => $color_dark, :background => $color_light)) { |q| q.in = (states << states.map{|state| state.downcase}).flatten }
    choose do |menu|
      menu.prompt = "What climate does #{location_options[:name]} have?".bold.colorize(:color => $color_dark, :background => $color_light)
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
    location_options[:employment_outlook] = ask("What employment possibilities exist in #{location_options[:name]}?".bold.colorize(:color => $color_dark, :background => $color_light)) { |q| q.default = "none" }
    location_options[:cost_of_living] = ask("How would you rate the cost of living of #{location_options[:name]}? (1-100)".bold.colorize(:color => $color_dark, :background => $color_light), Integer) { |q| q.in = 1..100}
    location_options[:notes] = ask("Any other information you'd like to add about #{location_options[:name]}?".bold.colorize(:color => $color_dark, :background => $color_light)) { |q| q.default = "none" }

    if find([location_options[:name].capitalize, location_options[:state_code].upcase]) != []
      puts "Sorry, that location already exists.".colorize(:color => $color_dark, :background => $color_light)
    else
      location = Location.new(location_options)
      location.save
      puts "Location added".bold.colorize(:color => $color_light, :background => $color_dark)
    end
  end

  def save
   database = Environment.database_connection
   database.execute("insert into locations(city, state_code, climate, employment_outlook, cost_of_living, notes) values('#{@name}', '#{@state_code}', '#{@climate}','#{@employment_outlook}', '#{@cost_of_living}', '#{@notes}')")
  end

  def self.find(search_city)
    city = search_city ? search_city[0] : nil
    state_code = search_city ? search_city[1] : nil
    database = Environment.database_connection
    if city and state_code
      results = database.execute("select distinct * from locations where city = '#{city}' and state_code = '#{state_code}'")
    else
      results = database.execute("select * from locations order by id asc")
    end
    database.results_as_hash = true
    results
  end

  def self.fetch_query(action = nil)
    database = Environment.database_connection
    database.results_as_hash = false
    results = database.execute("select city, state_code, climate, employment_outlook, cost_of_living, notes from locations order by id asc")
    choose do |menu|
      menu.prompt = "What city would you like to #{action}?".bold.colorize(:color => $color_dark, :background => $color_light)
      results.each do |city_state|
        menu.choice("#{city_state[0]}, #{city_state[1]}") do |chosen|
          city_state
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

  def self.remove(delete_city)
    database = Environment.database_connection
    cities_or_city = find(delete_city)
    # print cities_or_city.inspect
    plural = ''
    cities_or_city.each_with_index do |entry, i|
      database.execute("delete from locations where id = '#{entry[0]}'")
      plural = 's' if i > 0
    end
    puts "Location#{plural} Removed".bold.colorize(:color => $color_light, :background => $color_dark)
  end

  def self.update(old_data, new_data)
    database = Environment.database_connection
    item_to_update = find([old_data[0],old_data[1]]).flatten
    database.execute("update locations set city = '#{new_data[0].capitalize}', state_code = '#{new_data[1].upcase}', climate = '#{new_data[2].capitalize}', employment_outlook = '#{new_data[3]}', cost_of_living = '#{new_data[4].to_i}', notes = '#{new_data[5]}' where id = '#{item_to_update[0]}'")
    puts 'Location Updated'.bold.colorize(:color => $color_light, :background => $color_dark)
  end

  def self.fetch_replacement(old_data)
    old_data.map do |old|
      ask("The entry is currently: #{old}.  Type a new value or press ENTER to leave unchanged.".colorize(:color => $color_dark, :background => $color_light)) { |q| q.default = old }
    end
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
    database = Environment.database_connection
    database.results_as_hash = false
    results = database.execute("select * from locations #{where_string} order by id asc")
    results
  end


end
