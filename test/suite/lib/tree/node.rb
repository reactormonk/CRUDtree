BareTest.suite "CRUDtree" do

  suite "tree" do

    suite "node" do

      suite "initialize" do
        
        suite "paths" do

          assert "defaults to the name of the class" do
            Node.new(nil, klass: Node, model: Object){:foo}.paths == ["node"]
          end

          assert "raises if no path is given" do
            raises(ArgumentError) {Node.new(nil, foo: :bar){:foo}}
          end

        end

        assert "raises if no block is given" do
          raises(ArgumentError) {Node.new(nil, foo: :bar)}
        end
        
      end

      suite "extended subnodes" do

        setup :method, "#member" do
          @method = :member
        end

        setup :method, "#collection" do
          @method = :collection
        end

        setup :node, "node" do
          @node = Node.allocate
          @params = {foo: :bar}
          @result = @params.merge({type: @method})
          @node.expects(:endnode).with(@result)
        end

        assert ":method" do
          case @method
          when :member
            @node.member @params
          when :collection
            @node.collection @params
          end
          true
        end

      end

      suite "tree walking" do

        setup :master, "a simple master" do
          @master = Master.new
          @node = @master.node(klass: Object, model: Object){:foo}
          @parents = []
          @children = {}
        end

        suite "#parents" do

          setup :master, "a more complex master" do
            @master = Master.new
            @master.node(klass: Object, model: Object){
              node(klass: Object, model: Object){
                node(klass: Object, model: Object){:foo}
                node(klass: Object, model: Object){:foo}
              }
            }
            @node = @master.nodes.first.nodes.first.nodes.first
            @parents = [@master.nodes.first.nodes.first,@master.nodes.first]
          end

          assert "it find the parents in :master" do
            equal(@node.parents, @parents)
          end

        end

      end

    end

  end

end
