# bring in and mixin the CurrencyFormatter module, used to convert numbers in to a dollar format.
require 'currencyformatter'
include CurrencyFormatter

class Restaurant

	attr_reader :name
	attr_reader :cuisine
	attr_reader :price


	def initialize(name, cuisine, price)
		@name = name
		@cuisine = cuisine
		@price = price.to_f
	end

	# returns true if the instance's variables values contain ALL of the keywords supplied as arguments
	def contains_words?(words_to_search_for)
		words = split_variables_into_words
		words_to_search_for.each do |word|
			next if words.include?(word)
			return false
		end
		return true		
	end

	# Splits the values of each of the instance's variables into individual words, returning them as an array
	def split_variables_into_words
		words_split_from_vars = @name.downcase.split(" ") + @cuisine.downcase.split(" ")
		for num in 0..2
			words_split_from_vars << to_dollar_s(@price,num)
			words_split_from_vars << sprintf("%.#{num}f", @price)
		end
		words_split_from_vars
	end
	

	


end