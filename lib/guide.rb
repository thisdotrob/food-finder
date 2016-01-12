require 'restaurant'
require 'currencyformatter'

include CurrencyFormatter

class Guide

	@@console_width = 60
	@@filename = 'restaurants.txt'

	def initialize
		read_restaurants(@@filename)
		launch!
	end

	def launch!
		display_welcome_message
		while (user_keyword = user_cmds.first) != 'quit'
			case user_keyword
			when 'list' then list_restaurants
			when 'add' then add_restaurant
			when 'find' then find_restaurant
			else puts 'Command not recognised.'
			end
		end
		quit_and_save_to_file
	end

	def user_cmds
		@user_cmds = prompt("\nActions: list, find, add, quit\n\n").downcase.split(" ")
	end

	def display_welcome_message
		puts "\n\n\n<<< Welcome to Food Finder >>>\n\n"
		puts "This is an interactive guide to help you find the food you crave.\n"
	end

	def list_restaurants
		list_args = @user_cmds.drop(1)
		sort_criteria = get_sort_criteria(list_args)
		sort_restaurants(sort_criteria)
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

	def sort_restaurants(sort_criteria)
		case sort_criteria
			when 'cuisine' then @restaurants.sort_by! {|restaurant| restaurant.cuisine}
			when 'price' then @restaurants.sort_by! {|restaurant| restaurant.price}
			when 'name' then @restaurants.sort_by! {|restaurant| restaurant.name}
			else puts "\nPlease combine the list command with 'name', 'cuisine' or 'price'"
		end
	end

	def get_sort_criteria(list_args)
		if (list_args.size == 1) || (list_args.size == 2 && list_args[0] == 'by')
			return list_args.pop
		else
			return 'name'
		end
	end

	def puts_divider
		@@console_width.times {print "-"}; puts ''
	end

	def add_restaurant
		puts header("add a restaurant\n")
		name = prompt("Restaurant name: ")
		cuisine = prompt("Cuisine type: ")
		price = prompt_for_num("Average price: ")
		@restaurants << Restaurant.new(name,cuisine,price)
	end

	def find_restaurant
		keywords = @user_cmds.drop(1)
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
					price = to_dollar_s(restaurant.price, 2)
					puts three_column_line(name, cuisine, price)
				end
			end
			puts_divider
		end
	end

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

	def prompt(*args)
    print(*args)
    gets.chomp
	end

	def prompt_for_num(*args)
		while true
			if (num = prompt(*args).to_f) != 0.0 then return num
			else puts "\nPlease enter a numeric value.\n\n"
			end
		end
	end

	def header(string)
		header = "\n"
		header << string.upcase.center(@@console_width)
		header << "\n"
	end

end
