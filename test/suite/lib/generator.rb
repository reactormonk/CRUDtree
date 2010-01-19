require 'ostruct'
BareTest.suite do

  suite "CRUDtree" do

    suite "Generator" do

      suite "#compile_route_from_stem" do

        setup :stem, "a simple stem" do
          @stem = Stem.new(nil, :paths => ["foo"], klass: Object, model: Object ){:foo}
          @path = "/foo/:id"
        end

        setup :stem, "a stem with multiple parents" do
          trunk = Trunk.new
          trunk.stem(klass: Object, model: Object, paths: ["foo"]) do
            stem(klass: Object, model: Object, paths: ["bar"]) do
              stem(klass: Object, model: Object, paths: ["baz"]) {:foo}
            end
          end
          @stem = trunk.stems.first.stems.first.stems.first
          @path = "/foo/:id/bar/:id/baz/:id"
        end

        assert ":stem goes to the right path" do
          equal(@path, CRUDtree::Generator.allocate.send(:compile_route_from_stem, @stem))
        end

      end

      suite "#model_to_stem" do

        setup do
          class TestObj0; end
          class TestObj1; end
        end

        setup :trunk, "a simple trunk" do
          trunk = CRUDtree::Trunk.new
          trunk.stem(klass: Object, model: ::TestObj0) {:foo}
          @generator = CRUDtree::Generator.new(trunk)
          @stem = trunk.stems.first
          @model = ::TestObj0
        end

        setup :trunk, "a complex trunk" do
          trunk = CRUDtree::Trunk.new
          trunk.stem(klass: Object, model: ::TestObj1){
            stem(klass: Object, model: ::TestObj0){:foo}
          }
          @generator = CRUDtree::Generator.new(trunk)
          @stem = trunk.stems.first.stems.first
          @model = ::TestObj0
        end

        setup :trunk, "a trunk with duplicate models" do
          trunk = CRUDtree::Trunk.new
          trunk.stem(klass: Object, model: TestObj1){
            stem(klass: Object, model: ::TestObj0){:foo}
            stem(klass: Object, model: ::TestObj0){:foo}
          }
          @generator = CRUDtree::Generator.new(trunk)
          @stem = trunk.stems.first.stems
          @model = ::TestObj0
        end

        assert "The right model is found on :trunk." do
          equal(@stem, @generator.instance_variable_get(:@model_to_stem)[@model])
        end

      end

      suite "stem finding" do

        suite "without duplicates" do

          setup do
            @trunk = CRUDtree::Trunk.new
          end

          setup :trunk, "a simple trunk" do
            @stem = @trunk.stem(klass: Klass0, model: Model0){:foo}
            @resource = Model0.new
            @valid = [[Model0.new, @stem]]
            @invalid = [[Model2.new, @stem], [Model1.new, @stem]]
          end

          setup :trunk, "a complex trunk" do
            @trunk.stem(klass: Klass0, model: Model0) do
              stem(klass: Klass1, model: Model1){:foo}
              stem(klass: Klass2, model: Model2){:foo}
            end
            @stem = @trunk.stems.first.stems.last
            @resource = Model2.new
            @valid = [[Model2.new, @stem], [Model0.new, @trunk.stems.first]]
            @invalid = [[Model0.new, @stem], [Model1.new, @stem]]
          end

          assert "#valid_model_for_stem? is valid with :trunk" do
            generator = CRUDtree::Generator.new(@trunk)
            @valid.all?{|model, stem| generator.send(:valid_model_for_stem?, model, stem)}
          end

          assert "#valid_model_for_stem? invalid with :trunk" do
            generator = CRUDtree::Generator.new(@trunk)
            @invalid.all?{|model, stem| ! generator.send(:valid_model_for_stem?, model, stem)}
          end

          assert "#find_stem gets the correct stem from :trunk" do
            same(@stem, CRUDtree::Generator.new(@trunk).send(:find_stem, @resource))
          end

        end

        suite "with duplicates" do

          setup do
            @trunk = Trunk.new
            @trunk.stem(klass: Klass0, model: Mod0) do
              stem(klass: Klass1, model: Mod1){:foo}
              stem(klass: Klass2, model: Mod2) do
                stem(klass: Klass2, model: Mod2){:foo}
              end
            end
            @generator = CRUDtree::Generator.new(@trunk)
          end

          setup :stem, "nested stem" do
            @stem = @trunk.stems.first.stems.last.stems.first
            @resource = Mod2.new(Mod2)
          end

          setup :stem, "first stem" do
            @stem = @trunk.stems.first.stems.last
            @resource = Mod2.new(Mod0)
          end

          assert "#valid_model_for_stem? returns true for the :stem" do
            @generator.send(:valid_model_for_stem?, @resource, @stem)
          end

          assert "#find_stem gets the right model for the :stem" do
            same(@stem, @generator.send(:find_stem, @resource))
          end

        end

      end

    end

  end

end
