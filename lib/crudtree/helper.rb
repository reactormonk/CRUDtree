module CRUDtree
  module Interface
    module Helper
      def resource(params, &block)
        stem = @trunk.stem(params, &block)
        stem.collection(call: :index, rest: :get)
        stem.member(call: :show, rest: :get)
        stem.member(call: :new, rest: :get)
        stem.member(call: :create, rest: :post)
        stem.member(call: :edit, rest: :get)
        stem.member(call: :update, rest: :put)
        stem.member(call: :delete, rest: :get)
        stem.member(call: :destroy, rest: :delete)
      end
    end
  end
end
