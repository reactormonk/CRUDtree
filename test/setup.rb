$LOAD_PATH.unshift(File.expand_path("#{__FILE__}/../../lib")) # Add PROJECT/lib to $LOAD_PATH
require 'crudtree'
require 'mocha'
require 'baretest/use/mocha'
include CRUDtree
include Mocha::API
require 'ruby-debug'
