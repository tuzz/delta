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

    def pluck_intersection(a, b)
      a_attributes, b_attributes = pluck(a), pluck(b)
      b_attributes unless a_attributes == b_attributes
    end

    private

    attr_accessor :array, :struct

    class Null
      def pluck(object)
        object
      end

      def pluck_intersection(_, b)
        b
      end
    end
  end
end
