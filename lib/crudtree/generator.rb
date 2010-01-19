module CRUDtree
  class Generator
    def initialize(trunk)
      @trunk = trunk
      @model_to_stem = {}
      walk_tree_for_models
    end

    attr_reader :model_to_stem

    def generate(resource, call = nil)
      route = compile_route_from_stem(find_stem(resource))
      # TODO now leaf
    end

    private
    def find_stem(resource)
      case stems = @model_to_stem[resource]
      when Stem
        stems
      when Array
        valid_stem = stems.select {|stem| valid_model_for_stem?(resource, stem)}
        raise(NoUniqueStem, "No unique stem found for #{resource}.") unless valid_stem.size == 1
        raise(NoStem, "No stem found for #{resource}.") if valid_stem.size == 1
        valid_stem.first
      end
    end


    def walk_tree_for_models
      @trunk.stems.each {|stem| add_stem_models(stem) }
    end

    def add_stem_models(stem)
      @model_to_stem[stem.model] = if target_stem = @model_to_stem[stem.model]
                                     [target_stem + stem].flatten
                                   else
                                     stem
                                   end
      stem.branches.each { |leaf|
        add_stem_models(leaf) if leaf.class == Stem
      }
    end

    def compile_route_from_stem(stem)
      path = ""
      stem.parents.each {|parent|
        path << "/#{stem.paths.first}/:#{stem.identifier}"
      }
    end

    def valid_model_for_stem?(model, stem)
      return false unless stem.model == model.class
      if stem.parent.respond_to? :parent
        valid_model_for_stem?(model.send(stem.parent_call), stem.parent)
      else
        true
      end
    end
  end

  class NoUniqueStem < StandardError; end
  class NoStem < StandardError; end
end
