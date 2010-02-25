require_relative "../../helper/suite/lib/generator"
require 'ostruct'
BareTest.suite do

  suite "CRUDtree" do

    suite "Generator" do

      suite "#generate_url_from_node" do

        setup :node, "a simple node" do
          @node = Node.new(nil, :paths => ["foo"], klass: Object, model: Object ){:foo}
          @path = "/foo/23"
          @identifiers = [23]
        end

        setup :node, "a node with multiple parents" do
          master = Master.new
          master.node(klass: Object, model: Object, paths: ["foo"]) do
            node(klass: Object, model: Object, paths: ["bar"]) do
              node(klass: Object, model: Object, paths: ["baz"]) {:foo}
            end
          end
          @node = master.nodes.first.nodes.first.nodes.first
          @path = "/foo/1/bar/2/baz/3"
          @identifiers = [1,2,3]
        end

        assert ":node goes to the right path" do
          equal(@path, CRUDtree::Generator.allocate.send(:generate_url_from_node, @node, @identifiers))
        end

      end

      suite "#model_to_node" do

        setup do
          class ::TestObj0; end
          class ::TestObj1; end
        end

        setup :master, "a simple master" do
          master = CRUDtree::Master.new
          master.node(klass: Object, model: TestObj0) {:foo}
          @generator = CRUDtree::Generator.new(master)
          @node = master.nodes.first
          @model = TestObj0
        end

        setup :master, "a complex master" do
          master = CRUDtree::Master.new
          master.node(klass: Object, model: TestObj1){
            node(klass: Object, model: TestObj0){:foo}
          }
          @generator = CRUDtree::Generator.new(master)
          @node = master.nodes.first.nodes.first
          @model = TestObj0
        end

        setup :master, "a master with duplicate models" do
          master = CRUDtree::Master.new
          master.node(klass: Object, model: TestObj1){
            node(klass: Object, model: TestObj0){:foo}
            node(klass: Object, model: TestObj0){:foo}
          }
          @generator = CRUDtree::Generator.new(master)
          @node = master.nodes.first.nodes
          @model = TestObj0
        end

        setup :master, "a master with more than one model" do
          master = CRUDtree::Master.new
          master.node(klass: Object, model: [TestObj0, TestObj1]) {:foo}
          @generator = CRUDtree::Generator.new(master)
          @node = master.nodes.first
          @model = ::TestObj1
        end

        assert "The right node is found on :master." do
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
            @valid = [[Model0.new, @node, ["0"]]]
            @invalid = [[Model2.new, @node], [Model1.new, @node]]
          end

          setup :master, "a complex master" do
            @master.node(klass: Klass0, model: Model0) do
              node(klass: Klass1, model: Model1){:foo}
              node(klass: Klass2, model: Model2){:foo}
            end
            @node = @master.nodes.first.nodes.last
            @resource = Model2.new
            @valid = [[Model2.new, @node, ["0","2"]], [Model0.new, @master.nodes.first, ["0"]]]
            @invalid = [[Model0.new, @node], [Model1.new, @node]]
          end

          assert "#identifiers_returns the corret identifiers with :master" do
            generator = CRUDtree::Generator.new(@master)
            @valid.all?{|model, node, ary| generator.send(:identifiers_to_node, model, node) == ary}
          end

          assert "#identifiers returns false invalid with :master" do
            generator = CRUDtree::Generator.new(@master)
            @invalid.all?{|model, node| ! generator.send(:identifiers_to_node, model, node)}
          end

          assert "#find_node gets the correct node from :master" do
            same(@node, CRUDtree::Generator.new(@master).send(:find_node, @resource).first)
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
            @identifier = %w(0 2 2)
          end

          setup :node, "first node" do
            @node = @master.nodes.first.nodes.last
            @resource = Mod2.new(Mod0)
            @identifier = %w(0 2)
          end

          assert "#identifiers_to_node returns an Array of identifiers for the :node" do
            equal(@identifier, @generator.send(:identifiers_to_node, @resource, @node))
          end

          assert "#find_node gets :node based on the model" do
            same(@node, @generator.send(:find_node, @resource).first)
          end

        end

      end

      suite "#generate_from_sub" do

        setup do
          @foo = OpenStruct.new(:name => :foo, :path => "foo")
          @bar = OpenStruct.new(:name => :bar, :path => "bar")
        end

        setup :names, "one name" do
          @node = OpenStruct.new(:subs => [@foo, @bar])
          @names = [:foo]
          @path = "/foo"
        end

        setup :names, "stacked names" do
          @node = OpenStruct.new(:subs => [OpenStruct.new(:subs => [@foo, @bar], :name => :foo, :path => "foo"), @bar])
          @names = [:foo, :bar]
          @path = "/foo/bar"
        end

        assert "generates the correct url from :names" do
          url = ""
          Generator.allocate.send(:generate_from_sub, @node, @names, url)
          equal(@path, url)
        end

      end

      suite "blackbox" do

        setup do
          @master = Master.new
          @master.node(klass: Klass0, model: Mod0) do
            collection(call: :new)
            member(call: :delete)
            node(klass: Klass1, model: Mod1){:foo}
            node(klass: Klass2, model: Mod2) do
              member(call: :edit)
              collection(call: :post)
              node(klass: Klass2, model: Mod2){:foo}
            end
          end
          @generator = CRUDtree::Generator.new(@master)
        end

        setup :model, "model for the nested node" do
          @resource = Mod2.new(Mod2)
          @path = "/klass0/0/klass2/2/klass2/2"
        end

        setup :model, "model for the first node" do
          @resource = Mod2.new(Mod0)
          @path = "/klass0/0/klass2/2"
        end

        setup :model, "model for the simplest node" do
          @resource = Mod0.new
          @path = "/klass0/0"
        end

        setup :model, "collection on base node" do
          @resource = [:klass0, :new]
          @path = "/klass0/new"
        end

        setup :model, "member on base node" do
          @resource = [:klass0, :delete]
          @path = "/klass0/delete"
        end

        setup :model, "member on simple node" do
          @resource = [Mod2.new, :edit]
          @path = "/klass0/0/klass2/2/edit"
        end

        setup :model, "collection on simple node" do
          @resource = [Mod2.new, :post]
          @path = "/klass0/0/klass2/post"
        end

        assert "#generate with :model" do
          equal(@path, @generator.generate(*@resource))
        end

      end

    end

  end

end
