class Delta
  class Plucker
    def initialize(pluck)
      self.array = pluck
      self.struct = Struct.new(*array)
    end

    def pluck(object)
      attributes = array.map { |k| object.public_send(k) }
      struct.new(*attributes)
    end

    def pluck_intersection(from_object, to_object)
      from_attributes = pluck(from_object)
      to_attributes = pluck(to_object)

      from_attributes == to_attributes ? nil : to_attributes
    end

    private

    attr_accessor :array, :struct

    class Null
      def pluck(object)
        object
      end

      def pluck_intersection(_, to_object)
        to_object
      end
    end
  end
end
