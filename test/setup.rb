$LOAD_PATH.unshift(File.expand_path("#{__FILE__}/../../lib")) # Add PROJECT/lib to $LOAD_PATH
require 'crudtree'
require 'crudtree/interface/usher/rack'
require 'baretest/use/rr'
include CRUDtree
require 'ruby-debug'
