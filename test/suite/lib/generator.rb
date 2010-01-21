require 'ostruct'
BareTest.suite do

  suite "CRUDtree" do

    suite "Generator" do

      suite "#compile_route_from_node" do

        setup :node, "a simple node" do
          @node = Node.new(nil, :paths => ["foo"], klass: Object, model: Object ){:foo}
          @path = "/foo/:id"
        end

        setup :node, "a node with multiple parents" do
          master = Master.new
          master.node(klass: Object, model: Object, paths: ["foo"]) do
            node(klass: Object, model: Object, paths: ["bar"]) do
              node(klass: Object, model: Object, paths: ["baz"]) {:foo}
            end
          end
          @node = master.nodes.first.nodes.first.nodes.first
          @path = "/foo/:id/bar/:id/baz/:id"
        end

        assert ":node goes to the right path" do
          equal(@path, CRUDtree::Generator.allocate.send(:compile_route_from_node, @node))
        end

      end

      suite "#model_to_node" do

        setup do
          class TestObj0; end
          class TestObj1; end
        end

        setup :master, "a simple master" do
          master = CRUDtree::Master.new
          master.node(klass: Object, model: ::TestObj0) {:foo}
          @generator = CRUDtree::Generator.new(master)
          @node = master.nodes.first
          @model = ::TestObj0
        end

        setup :master, "a complex master" do
          master = CRUDtree::Master.new
          master.node(klass: Object, model: ::TestObj1){
            node(klass: Object, model: ::TestObj0){:foo}
          }
          @generator = CRUDtree::Generator.new(master)
          @node = master.nodes.first.nodes.first
          @model = ::TestObj0
        end

        setup :master, "a master with duplicate models" do
          master = CRUDtree::Master.new
          master.node(klass: Object, model: TestObj1){
            node(klass: Object, model: ::TestObj0){:foo}
            node(klass: Object, model: ::TestObj0){:foo}
          }
          @generator = CRUDtree::Generator.new(master)
          @node = master.nodes.first.nodes
          @model = ::TestObj0
        end

        assert "The right model is found on :master." do
          equal(@node, @generator.instance_variable_get(:@model_to_node)[@model])
        end

      end

      suite "node finding" do

        suite "without duplicates" do

          setup do
            @master = CRUDtree::Master.new
          end

          setup :master, "a simple master" do
            @node = @master.node(klass: Klass0, model: Model0){:foo}
            @resource = Model0.new
            @valid = [[Model0.new, @node]]
            @invalid = [[Model2.new, @node], [Model1.new, @node]]
          end

          setup :master, "a complex master" do
            @master.node(klass: Klass0, model: Model0) do
              node(klass: Klass1, model: Model1){:foo}
              node(klass: Klass2, model: Model2){:foo}
            end
            @node = @master.nodes.first.nodes.last
            @resource = Model2.new
            @valid = [[Model2.new, @node], [Model0.new, @master.nodes.first]]
            @invalid = [[Model0.new, @node], [Model1.new, @node]]
          end

          assert "#valid_model_for_node? is valid with :master" do
            generator = CRUDtree::Generator.new(@master)
            @valid.all?{|model, node| generator.send(:valid_model_for_node?, model, node)}
          end

          assert "#valid_model_for_node? invalid with :master" do
            generator = CRUDtree::Generator.new(@master)
            @invalid.all?{|model, node| ! generator.send(:valid_model_for_node?, model, node)}
          end

          assert "#find_node gets the correct node from :master" do
            same(@node, CRUDtree::Generator.new(@master).send(:find_node, @resource))
          end

        end

        suite "with duplicates" do

          setup do
            @master = Master.new
            @master.node(klass: Klass0, model: Mod0) do
              node(klass: Klass1, model: Mod1){:foo}
              node(klass: Klass2, model: Mod2) do
                node(klass: Klass2, model: Mod2){:foo}
              end
            end
            @generator = CRUDtree::Generator.new(@master)
          end

          setup :node, "nested node" do
            @node = @master.nodes.first.nodes.last.nodes.first
            @resource = Mod2.new(Mod2)
          end

          setup :node, "first node" do
            @node = @master.nodes.first.nodes.last
            @resource = Mod2.new(Mod0)
          end

          assert "#valid_model_for_node? returns true for the :node" do
            @generator.send(:valid_model_for_node?, @resource, @node)
          end

          assert "#find_node gets the right model for the :node" do
            same(@node, @generator.send(:find_node, @resource))
          end

        end

      end

    end

  end

end
