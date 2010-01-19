def results_in(path, klass, call, params)
  klass.expects(call).returns(:yeah!)
  to_mock = mock('to')
  to_mock.expects(:to).with(:yeah!).returns(true)
  Usher::Interface.class_for(:rack).any_instance.expects(:path).with(path, params).returns(to_mock)
end

module Usher; module Interface; class Rack;
  include CRUDtree::Interface::Usher::Rack
  def initialize(app = nil, options = nil, &block) 
    instance_eval(&block) if block
  end
end; end; end
class TestObj0; end
class TestObj1; end
class TestObj2; end

def default_routes(number=0)
  default_route(TestObj0)
  default_route(TestObj1, "/testobj0/:id") if number > 0
  default_route(TestObj2, "/testobj0/:id/testobj1/:id") if number > 1
end

def default_route(klass, pre_path=nil)
  results_in("#{pre_path}/#{klass.to_s.downcase}", klass, :index, :conditions => {:request_method => "GET"})
  results_in("#{pre_path}/#{klass.to_s.downcase}/:id", klass, :show, :conditions => {:request_method => "GET"})
end
module Usher
  module Interface
    def self.class_for(interface)
      Rack
    end
    class Rack
    end
  end
end
