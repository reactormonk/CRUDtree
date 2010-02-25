require_relative "../../helper/suite/lib/integration"

require 'crudtree/interface/usher/rack'
module Usher
  module Interface
    class Rack
      def initialize(app = nil, options = nil, &blk)
      end
    end
  end
end

BareTest.suite do

  suite "CRUDtree" do

    suite "integartion" do

      suite "inclusion" do

        setup do
          CRUDtree::Interface.for(:usher_rack)
        end

        assert "the module gets included and the methods are avaible" do
          Usher::Interface.class_for(:rack).new.respond_to? :node
        end

      end

    end

  end

end
