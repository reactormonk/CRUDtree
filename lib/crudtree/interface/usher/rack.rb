require_relative '../usher'

module CRUDtree
  module Interface
    module Usher
      module Rack
        include CRUDtree::Interface::Usher

        def self.attach
          ::Usher::Interface.class_for(:rack).send(:include, self)
        end

        def self.add_helper(helper)
          include helper
        end

        private
        def compile_endnode(pre_path, endnode)
          conditions = {}
          conditions.merge!({request_method: endnode.rest.to_s.upcase}) if endnode.rest
          method_call = [endnode.call]
          method_call.unshift(:dispatcher) if master_params[:rango]
          # Here we call usher.
          path(compile_path(pre_path, endnode), conditions: conditions).to(endnode.parent.klass.send(*method_call))
        end

        def compile_path(pre_path, endnode)
          node = endnode.parent
          compiled_path = [pre_path]
          compiled_path << ":#{node.identifier}" if endnode.type == :member
          compiled_path << "#{endnode.path}" unless endnode.path.empty?
          compiled_path.join('/')
        end

      end
    end
  end
end

CRUDtree::Interface.register(:usher_rack, CRUDtree::Interface::Usher::Rack)
