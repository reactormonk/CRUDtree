module CRUDtree
  module Interface
    module Helper
      def resource(params, &resource_block)
        node(params) do
          collection(call: :index, rest: :get)
          collection(call: :new, rest: :get)
          collection(call: :create, rest: :post, path: "")
          member(call: :show, rest: :get)
          member(call: :edit, rest: :get)
          member(call: :update, rest: :put, path: "")
          member(call: :delete, rest: :get)
          member(call: :destroy, rest: :delete, path: "")
          instance_eval(&resource_block) if resource_block
        end
      end
    end
  end
end
