require 'highline/import'

class Location
  attr_accessor :name, :state_code, :climate
  def initialize(options)
    @name = options[:name]
    @state_code = options[:state_code].upcase
    @climate = options[:climate]
  end


  def self.add
    location_options = {}
    location_options[:name] = ask("What is the name of the city or town you wish to add?") { |q| q.default = "none" }
    location_options[:state_code] = ask("What state is #{location_options[:name]} in?") { |q| q.validate = /[a-zA-Z][a-zA-Z]/ }
    choose do |menu|
      menu.prompt = "What climate does #{location_options[:name]} have?"
      menu.choice(:Cool) do |chosen|
        location_options[:climate] = 'Cool'
      end
      menu.choice(:Temperate) do |chosen|
        location_options[:climate] = 'Temperate'
      end
      menu.choice(:Warm) do |chosen|
        location_options[:climate] = 'Warm'
      end
    end
    location = Location.new(location_options)
    puts location.inspect
    location.save
  end

  def save
   database = Environment.database_connection
   database.execute("insert into locations(city, state_code, climate) values('#{@name}', '#{@state_code}', '#{@climate}')")
  end

  def self.read
   database = Environment.database_connection
   results = database.execute("select * from locations order by id asc")
   database.results_as_hash = true
   puts results.inspect
    # results = database.execute("select purchases.* from purchases where name LIKE '%#{search_term}%' order by name ASC")
    # results.map do |row_hash|
    #   purchase = Purchase.new(
    #               name: row_hash["name"],
    #               price: row_hash["price"],
    #               calories: row_hash["calories"])
    #   # Ideally: purchase.category = Category.find(row_hash["category_id"])
    #   # Not Ideally :(
    #   category = Category.all.find{|category| category.id == row_hash["category_id"]}
    #   purchase.category = category
    #   purchase.send("id=", row_hash["id"])
    #   purchase
  end

end
