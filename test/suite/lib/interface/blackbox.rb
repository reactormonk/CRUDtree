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

     setup :tree, "a nested tree" do
      @block = proc {
        stem(klass: TestObj0) do
          stem(klass: TestObj1) do
            member(call: :show, rest: :get)
          end
        end
      }
      results_in("/testobj0/:id/testobj1/:id/show", TestObj1, :show, :conditions => {:request_method => "GET"})
     end

     setup :tree, "a twice nested tree" do
      @block = proc {
        stem(klass: TestObj0) do
          stem(klass: TestObj1) do
            stem(klass: TestObj2) do
              collection(call: :create, rest: :post)
            end
          end
        end
      }
      results_in("/testobj0/:id/testobj1/:id/testobj2/create", TestObj2, :create, :conditions => {:request_method => "POST"})
     end

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
