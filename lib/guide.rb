# bring in the restaurant class
require 'restaurant'

# bring in and mixin the CurrencyFormatter module, used to convert numbers in to a dollar format.
require 'currencyformatter'
include CurrencyFormatter

class Guide

	# Sets the width of tables displayed in the console
	@@console_width = 60

	# Name of the file to read/write the list of restaurants
	@@filename = 'restaurants.txt'

	# Reads in the list of restaurants from the text file and start the user interface
	def initialize
		read_restaurants(@@filename)
		launch!
	end

	# Displays welcome message and runs the main user interface prompt
	def launch!
		display_welcome_message
		while true
			@user_cmd = prompt("\nActions: list, find, add, quit\n\n").downcase.split(" ")		
			case @user_cmd[0]
			when 'list' then list_restaurants(@user_cmd.drop(1))
			when 'add' then add_restaurant
			when 'find' then find_restaurant(@user_cmd.drop(1))
			when 'quit' then quit_and_save_to_file
			else puts 'Command not recognised.'
			end
		end
	end 

	def display_welcome_message
		puts "\n\n\n<<< Welcome to Food Finder >>>\n\n"
		puts "This is an interactive guide to help you find the food you crave.\n"
	end

	# Lists the details of each restaurant, first sorting according to the second paramter
	# given by the user if there is one (otherwise sorting by name as default)
	def list_restaurants(list_args)
		if (list_args.size == 1) || (list_args.size == 2 && list_args[0] == 'by')
			sort_criteria = list_args.pop		
		else 
			sort_criteria = 'name'
		end
		case sort_criteria
			when 'cuisine' then @restaurants.sort_by! {|restaurant| restaurant.cuisine}
			when 'price' then @restaurants.sort_by! {|restaurant| restaurant.price}
			when 'name' then @restaurants.sort_by! {|restaurant| restaurant.name}
			else return puts "\nPlease combine the list command with 'name', 'cuisine' or 'price'"
		end
		puts header("listing restaurants\n")
		puts three_column_line("Name","Cuisine","Price")
		puts_divider					
		@restaurants.each do |restaurant|
			name = restaurant.name
			cuisine = restaurant.cuisine
			price = to_dollar_s(restaurant.price, 2)
			puts three_column_line(name, cuisine, price)
		end
		puts_divider
		puts "Sort using: 'list cuisine' or 'list by cuisine'"		
	end

	def puts_divider
		@@console_width.times {print "-"}; puts ''
	end

	# adds a restaurant object to the @restaurants array, prompting the user for the values of each variable
	def add_restaurant
		puts header("add a restaurant\n")
		name = prompt("Restaurant name: ")
		cuisine = prompt("Cuisine type: ")
		price = prompt_for_num("Average price: ")
		@restaurants << Restaurant.new(name,cuisine,price)
	end

	# Displays a list of restaurants that contain the keyword within their variable values.
	def find_restaurant(keywords)
		puts header("find a restaurant\n")
		if keywords.empty?
			puts "Find using a key phrase to search the restaurant list."
			puts "Examples: 'find tamale', 'find mexican', 'find mex'"
		else
			puts three_column_line("Name","Cuisine","Price")
			puts_divider
			@restaurants.each do |restaurant| 
				if restaurant.contains_words?(keywords)
					name = restaurant.name
					cuisine = restaurant.cuisine
					price = to_dollar_s(restaurant.price, 2)	# convert the float/integer into a 2 decimal place dollar string
					puts three_column_line(name, cuisine, price)
				end
			end
			puts_divider
		end
	end

	# format three strings into a 3 column line
	def three_column_line(string1, string2, string3)
		line = " " << string1.ljust(30)
		line << " " + string2.ljust(20)
		line << " " + string3.rjust(6)
	end

	def quit_and_save_to_file
		puts "\n<<< Goodbye and Bon Appetit! >>>"
		write_restaurants(@@filename)
		exit
	end

	def read_restaurants(filename)
		if File.exist?(filename) && File.file?(filename)
			file = File.open(filename, 'r')
		else
			file = File.new(filename, 'r')
		end
		@restaurants = []
		while (line = file.gets) != nil
			array = line.chomp.split("\t")
			restaurant = Restaurant.new(array[0],array[1],array[2].to_f)
			@restaurants << restaurant
		end
		file.close
	end

	def write_restaurants(filename)
		if File.exist?(filename) && File.file?(filename)
			file = File.open(filename, 'w')
		else
			file = File.new(filename, 'w')
		end	

		@restaurants.each do |restaurant|
			file.puts "#{restaurant.name}\t#{restaurant.cuisine}\t#{restaurant.price}"
		end

		file.close
	end

	# prompt the user for a command
	def prompt(*args)
    print(*args)
    gets.chomp
	end

	# prompt the user for a number, validating it and re-prompting if necessary
	def prompt_for_num(*args)
		while true
			if (num = prompt(*args).to_f) != 0.0 then return num
			else puts "\nPlease enter a numeric value.\n\n"
			end		
		end
	end

	# turn a string into a centered all-caps header
	def header(string)
		header = "\n"
		header << string.upcase.center(@@console_width)
		header << "\n"
	end
	
end


