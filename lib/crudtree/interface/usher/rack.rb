require_relative '../usher'

module CRUDtree
  module Interface
    module Usher
      module Rack
        include CRUDtree::Interface::Usher

        def self.attach
          Usher::Interface::Rack.include self
        end

        private
        def compile_path(pre_path, stem, leaf)
          conditions = {}
          conditions.merge!({request_method: leaf.rest.to_s.upcase}) if leaf.rest
          method_call = [leaf.call]
          method_call.unshift(:dispatcher) if trunk_params[:rango]
          path("#{pre_path}/#{leaf.path}", conditions: conditions).to(stem.klass.send(*method_call))
        end
      end
    end
  end
end

CRUDtree::Interface.register(:usher_rack, CRUDtree::Interface::Usher::Rack)
