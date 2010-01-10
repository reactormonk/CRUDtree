require_relative '../usher'

module CRUDtree
  module Interface
    module Usher
      module Rack
        include CRUDtree::Interface::Usher

        def self.attach
          ::Usher::Interface::Rack.send(:include, self)
        end

        def self.add_helper(helper)
          include helper
        end

        private
        def compile_path(pre_path, leaf)
          conditions = {}
          conditions.merge!({request_method: leaf.rest.to_s.upcase}) if leaf.rest
          method_call = [leaf.call]
          method_call.unshift(:dispatcher) if trunk_params[:rango]
          path(compile_path_string(pre_path, leaf), conditions: conditions).to(leaf.parent.klass.send(*method_call))
        end

        def compile_path_string(pre_path, leaf)
          stem = leaf.parent
          compiled_path = [pre_path]
          compiled_path << recursive_path_walking(stem.parent) if stem.parent.respond_to? :parent
          compiled_path << "#{stem.path}"
          compiled_path << ":#{stem.identifier}" if leaf.type == :member
          compiled_path << "#{leaf.path}"
          compiled_path.join('/')
        end

        def recursive_path_walking(stem)
          ret = []
          ret << recursive_path_walking(stem.parent) if stem.parent.respond_to? :parent
          ret << "#{stem.path}"
          ret << ":#{stem.identifier}"
          ret.flatten
        end

      end
    end
  end
end

CRUDtree::Interface.register(:usher_rack, CRUDtree::Interface::Usher::Rack)
