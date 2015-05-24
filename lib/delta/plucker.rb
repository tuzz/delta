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

    private

    attr_accessor :array, :struct

    class Null
      def pluck(object)
        object
      end
    end
  end
end
