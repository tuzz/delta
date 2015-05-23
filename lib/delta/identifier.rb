class Delta
  class Identifier
    def initialize(keys)
      self.keys = keys
    end

    def identity(object)
      keys.map { |k| object.public_send(k) }
    end

    private

    attr_accessor :keys

    class Null
      def identity(object)
        object
      end
    end
  end
end
