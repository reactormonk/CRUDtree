require_relative '../../helper/suite/lib/blackbox'
BareTest.suite "CRUDtree" do

  suite "blackbox", :use => :rr do

    setup do
      @interface = Usher::Interface::Rack.new
    end

    setup :tree, "an extremely simple tree" do
      @block = proc {
        node(model: Object, klass: TestObj0) { }
      }
      default_routes
    end

    setup :tree, "a simple tree" do
      @block = proc {
        node(model: Object, klass: TestObj0) do
          collection(call: :foo, rest: :get)
        end
      }
      results_in("/test_obj0/foo", TestObj0, :foo, :conditions => {:request_method => "GET"})
      # default routes
      default_routes
    end

     setup :tree, "a nested tree" do
      @block = proc {
        node(model: Object, klass: TestObj0) do
          node(model: Object, klass: TestObj1) do
            member(call: :show, rest: :get)
          end
        end
      }
      results_in("/test_obj0/:id/test_obj1/:id/show", TestObj1, :show, :conditions => {:request_method => "GET"})
      # default routes
      default_routes(1)
     end

     setup :tree, "a twice nested tree" do
      @block = proc {
        node(model: Object, klass: TestObj0) do
          node(model: Object, klass: TestObj1) do
            node(model: Object, klass: TestObj2) do
              collection(call: :create, rest: :post)
            end
          end
        end
      }
      results_in("/test_obj0/:id/test_obj1/:id/test_obj2/create", TestObj2, :create, :conditions => {:request_method => "POST"})
      # default routes
      default_routes(2)
     end

     setup :tree, "a tree with some subnodes" do
      @block = proc {
        node(model: Object, klass: TestObj0) do
          collection(call: :index, rest: :get)
          member(call: :show, rest: :get)
          member(call: :update, path: "edit", rest: :put)
        end
      }
      results_in("/test_obj0/index", TestObj0, :index, :conditions => {:request_method => "GET"})
      results_in("/test_obj0/:id/edit", TestObj0, :update, :conditions => {:request_method => "PUT"})
      results_in("/test_obj0/:id/show", TestObj0, :show, :conditions => {:request_method => "GET"})
      # default routes
      default_routes
     end

     setup :tree, "a nested tree with some subnodes" do
      @block = proc {
        node(model: Object, klass: TestObj0) do
          member(call: :show, rest: :get)
          node(model: Object, klass: TestObj1) do
            collection(call: :index, rest: :get)
            member(call: :show, rest: :get)
            member(call: :update, path: "edit", rest: :put)
          end
        end
      }
      results_in("/test_obj0/:id/show", TestObj0, :show, :conditions => {:request_method => "GET"})
      results_in("/test_obj0/:id/test_obj1/index", TestObj1, :index, :conditions => {:request_method => "GET"})
      results_in("/test_obj0/:id/test_obj1/:id/show", TestObj1, :show, :conditions => {:request_method => "GET"})
      results_in("/test_obj0/:id/test_obj1/:id/edit", TestObj1, :update, :conditions => {:request_method => "PUT"})
      # default routes
      default_routes(1)
     end

     setup :tree, "a tree with multiple paths" do
      @block = proc {
        node(model: Object, paths: ["test", "foo", "bar"], klass: TestObj0) do
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
        node(model: Object, paths: ["foo", "bar"], klass: TestObj0) do
          collection(call: :index, rest: :get)
          node(model: Object, paths: ["test", "baz"], klass: TestObj1) do
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
      @interface.instance_eval &@block
    end

  end

end
