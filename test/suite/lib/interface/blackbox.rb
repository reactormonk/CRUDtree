BareTest.suite "CRUDtree" do

  suite "blackbox" do

    setup :tree, "a simple tree" do
      @block = proc {
        stem(klass: TestObj0) do
          collection(call: :index, rest: :get)
        end
      }
      results_in("/testobj0/index", TestObj0, :index, :conditions => {:request_method => "GET"})
      # default routes
      results_in("/testobj0", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
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
      # default routes
      results_in("/testobj0", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1/:id", TestObj1, :show, :conditions => {:request_method => "GET"})
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
      # default routes
      results_in("/testobj0", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1/:id", TestObj1, :show, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1/:id/testobj2", TestObj2, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1/:id/testobj2/:id", TestObj2, :show, :conditions => {:request_method => "GET"})
     end

     setup :tree, "a tree with some leafs" do
      @block = proc {
        stem(klass: TestObj0) do
          collection(call: :index, rest: :get)
          member(call: :show, rest: :get)
          member(call: :update, path: "edit", rest: :put)
        end
      }
      results_in("/testobj0/index", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/edit", TestObj0, :update, :conditions => {:request_method => "PUT"})
      results_in("/testobj0/:id/show", TestObj0, :show, :conditions => {:request_method => "GET"})
      # default routes
      results_in("/testobj0", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
     end

     setup :tree, "a nested tree with some leafs" do
      @block = proc {
        stem(klass: TestObj0) do
          member(call: :show, rest: :get)
          stem(klass: TestObj1) do
            collection(call: :index, rest: :get)
            member(call: :show, rest: :get)
            member(call: :update, path: "edit", rest: :put)
          end
        end
      }
      results_in("/testobj0/:id/show", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1/index", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1/:id/show", TestObj1, :show, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1/:id/edit", TestObj1, :update, :conditions => {:request_method => "PUT"})
      # default routes
      results_in("/testobj0", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/testobj0/:id/testobj1/:id", TestObj1, :show, :conditions => {:request_method => "GET"})
     end

     setup :tree, "a tree with multiple paths" do
      @block = proc {
        stem(paths: ["test", "foo", "bar"], klass: TestObj0) do
          collection(call: :index, rest: :get)
        end
      }
      results_in("/test/index", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/foo/index", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/bar/index", TestObj0, :index, :conditions => {:request_method => "GET"})
      # default routes
      results_in("/test", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/foo", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/bar", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/test/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/foo/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/bar/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
     end

     setup :tree, "a nested tree with multiple paths" do
      @block = proc {
        stem(paths: ["foo", "bar"], klass: TestObj0) do
          collection(call: :index, rest: :get)
          stem(paths: ["test", "baz"], klass: TestObj1) do
            member(call: :edit, rest: :get)
          end
        end
      }
      results_in("/foo/index", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/bar/index", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/foo/:id/test/:id/edit", TestObj1, :edit, :conditions => {:request_method => "GET"})
      results_in("/bar/:id/test/:id/edit", TestObj1, :edit, :conditions => {:request_method => "GET"})
      results_in("/foo/:id/baz/:id/edit", TestObj1, :edit, :conditions => {:request_method => "GET"})
      results_in("/bar/:id/baz/:id/edit", TestObj1, :edit, :conditions => {:request_method => "GET"})
      # default routes
      results_in("/foo", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/bar", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/foo/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/bar/:id", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/foo/:id/test", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/bar/:id/test", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/foo/:id/baz", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/bar/:id/baz", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/foo/:id/test/:id", TestObj1, :show, :conditions => {:request_method => "GET"})
      results_in("/bar/:id/test/:id", TestObj1, :show, :conditions => {:request_method => "GET"})
      results_in("/foo/:id/baz/:id", TestObj1, :show, :conditions => {:request_method => "GET"})
      results_in("/bar/:id/baz/:id", TestObj1, :show, :conditions => {:request_method => "GET"})
     end

    assert "compilation of :tree" do
      Usher::Interface::Rack.new(&@block)
    end

  end

end
