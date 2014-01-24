require 'optparse'

class ParseArguments
  def self.parse
    options = { environment: "production" }
    OptionParser.new do |opts|
      opts.banner = "Usage: locations [command] [options]"

      opts.on("--price [PRICE]", "The price") do |price|
        options[:price] = price
      end

      opts.on("--calories [CALORIES]", "The calories") do |calories|
        options[:calories] = calories
      end

      opts.on("--environment [ENV]", "The database environment") do |env|
        options[:environment] = env
      end
    end.parse!
    options
  end

  def self.validate options
    errors = []
    if options[:name].nil? or options[:name].empty?
      errors << "You must provide the name of the product you are adding.\n"
    end

    missing_things = []
    missing_things << "price" unless options[:price]
    missing_things << "total calories" unless options[:calories]
    unless missing_things.empty?
      errors << "You must provide the #{missing_things.join(" and ")} of the product you are adding.\n"
    end
    errors
  end
end
