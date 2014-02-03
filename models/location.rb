require 'highline/import'

class Location
  attr_accessor :name, :state_code, :climate
  def initialize(options)
    @name = options[:name].capitalize
    @state_code = options[:state_code].upcase
    @climate = options[:climate]
  end


  def self.add
    location_options = {}
    location_options[:name] = ask("What is the name of the city or town you wish to add?") { |q| q.default = "none" }
    location_options[:state_code] = ask("What state is #{location_options[:name]} in?") { |q| q.validate = /^[a-zA-Z][a-zA-Z]$/ }
    choose do |menu|
      menu.prompt = "What climate does #{location_options[:name]} have?"
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
    if find([location_options[:name].capitalize, location_options[:state_code].upcase]) != []
      puts "Sorry, that location already exists."
    else
      location = Location.new(location_options)
      location.save
      puts "Location added"
    end
  end

  def save
   database = Environment.database_connection
   database.execute("insert into locations(city, state_code, climate) values('#{@name}', '#{@state_code}', '#{@climate}')")
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
    results = database.execute("select city, state_code, climate from locations order by id asc")
    choose do |menu|
      menu.prompt = "What city would you like to #{action}?"
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
    puts "Location#{plural} Removed"
    # database.execute("delete from locations")
  end

  def self.update(old_data, new_data)
    database = Environment.database_connection
    item_to_update = find([old_data[0],old_data[1]]).flatten
    database.execute("update locations set city = '#{new_data[0].capitalize}', state_code = '#{new_data[1].upcase}', climate = '#{new_data[2].capitalize}' where id = '#{item_to_update[0]}'")
    puts 'Location Updated'
  end

  def self.fetch_replacement(old_data)
    # use map
    old_data.map do |old|
      ask("The entry is currently: #{old}.  Type a new value or press ENTER to leave unchanged.") { |q| q.default = old }
    end
  end

end
