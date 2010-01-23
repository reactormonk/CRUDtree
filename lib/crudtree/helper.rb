module CRUDtree
  module Interface
    module Helper
      def resource(params, &block)
        resource_node = node(params, &block)
        resource_node.collection(call: :index, rest: :get)
        resource_node.collection(call: :new, rest: :get)
        resource_node.collection(call: :create, rest: :post, path: "")
        resource_node.member(call: :show, rest: :get)
        resource_node.member(call: :edit, rest: :get)
        resource_node.member(call: :update, rest: :put, path: "")
        resource_node.member(call: :delete, rest: :get)
        resource_node.member(call: :destroy, rest: :delete, path: "")
      end
    end
  end
end
