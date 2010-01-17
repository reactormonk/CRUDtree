BareTest.suite "CRUDtree" do

  suite "blackbox" do

    setup do
    end

    setup :tree, "a simple tree" do
      @block = proc {
        stem(klass: TestObj0) do
          collection(call: :index, rest: :get)
        end
      }
      results_in("/testobj0/index", TestObj0, :index, :conditions => {:request_method => "GET"})
    end

#     setup :tree, "a nested tree" do
#     end

#     setup :tree, "a twice nested tree" do
#     end

#     setup :tree, "a tree with some leafs" do
#     end

#     setup :tree, "a nested tree with some leafs" do
#     end

#     setup :tree, "a tree with multiple paths" do
#     end

#     setup :tree, "a nested tree with multiple paths" do
#     end

    assert "compilation of :tree" do
      Usher::Interface::Rack.new(&@block)
    end

  end

end
