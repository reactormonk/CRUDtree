$LOAD_PATH.unshift(File.expand_path("#{__FILE__}/../../lib")) # Add PROJECT/lib to $LOAD_PATH
require 'crudtree'

CRUDtree::Interface.register(:mock, Mock = proc {|klass, stem| [klass, stem]})
