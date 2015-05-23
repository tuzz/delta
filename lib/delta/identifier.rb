class Identifier
  def initialize(keys)
    @keys = keys
  end

  def identity(object)
    @keys.map { |k| object.public_send(k) }
  end

  private

  class Null
    def identity(object)
      object
    end
  end
end
