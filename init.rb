##  Food Finder ##
#
#  Launch this file from ruby to start the application
#	
	
APP_ROOT = File.dirname(__FILE__)			# directory of THIS file


$:.unshift( File.join(APP_ROOT, 'lib') )	# $: contains array of all folders for Ruby to look in for files. We point it to lib folder only


require 'guide'								# bring in guide.rb

guide = Guide.new()





