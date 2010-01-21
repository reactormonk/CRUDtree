module CRUDtree
  module Interface
    module Helper
      def resource(params, &block)
        node = @master.node(params, &block)
        node.collection(call: :index, rest: :get)
        node.member(call: :show, rest: :get)
        node.member(call: :new, rest: :get)
        node.member(call: :create, rest: :post)
        node.member(call: :edit, rest: :get)
        node.member(call: :update, rest: :put)
        node.member(call: :delete, rest: :get)
        node.member(call: :destroy, rest: :delete)
      end
    end
  end
end
