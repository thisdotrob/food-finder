APP_ROOT = File.dirname(__FILE__)

$:.unshift( File.join(APP_ROOT, 'lib') )	# $: contains array of all folders for Ruby to look in for files. We point it to lib folder only

require 'guide'

guide = Guide.new()
