## Delta

Calculates the delta between two collections of objects.

## Usage

In its simplest form, Delta calculates the additions and deletions for arbitrary
collections of objects:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree]
)

delta.additions
#=> #<Enumerator: ... >

delta.additions.to_a
#=> [
  #<Pokemon @species="Raichu", @name="Zappy", @level=30, @type="Electric">,
  #<Pokemon @species="Butterfree", @name="Flappy", @level=20, @type="Flying">
]

delta.deletions.to_a
#=> [
  #<Pokemon @species="Pikachu", @name="Zappy", @level=29, @type="Electric">,
  #<Pokemon @species="Magikarp", @name="Splashy", @level=5, @type="Water">
]
```

## Modifications

In some cases, it may be more appropriate to think in terms of modifications
rather than additions and deletions.

By default, Delta uses
[object equality](http://ruby-doc.org/core-2.2.2/Object.html#method-i-eql-3F) to
calculate differences. If you want to change this, you can specify the `keys`
that uniquely identify each object:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  keys: [:name]
)

delta.additions.to_a
#=> [#<Pokemon @species="Butterfree", @name="Flappy", @level=20, @type="Flying">]

delta.modifications.to_a
#=> [#<Pokemon @species="Raichu", @name="Zappy", @level=30, @type="Electric">]

delta.deletions.to_a
#=> [#<Pokemon @species="Magikarp", @name="Splashy", @level=5, @type="Water">]
```

In this example, 'Zappy' has had his species modified, but he is still the same
Pokemon. This may be more semantically correct, depending on your domain.

## Composite Keys

Sometimes an object will be uniquely identified by a combination of things. If
this is the case, you can specify a composite key.

For example, if your application enforces that the names of Pokemon must only be
unique within a particular type, the following may be more appropriate:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  keys: [:name, :type] # <-- Composite key
)

delta.additions.to_a
#=> [#<Pokemon @species="Butterfree", @name="FANG!", @level=20, @type="Flying">]

delta.modifications.to_a
#=> [#<Pokemon @species="Raichu", @name="Zappy", @level=30, @type="Electric">]

delta.deletions.to_a
#=> [#<Pokemon @species="Magikarp", @name="FANG!", @level=20, @type="Water">]
```

In this example, a single key of 'name' would not be sufficient to uniquely
identify objects as there are two Pokemon called 'FANG!'.

TODO: What would happen if you did that? Should it raise an error?

## Pluck

In some cases, you may only be interested in a handful of attributes. Delta
supports `pluck`, which selects only the attributes you want, instead of
returning full objects:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  pluck: [:level, :species]
)

delta.additions.to_a
#=> [#<struct level=30, species="Raichu">, #<struct level=20, type="Butterfree">]

delta.modifications.to_a
#=> []

delta.deletions.to_a
#=> [#<struct level=29, type="Pikachu">, #<struct level=5, type="Magikarp">]
```

## Many-to-one Deltas

By combinating `keys` and `pluck` you can build deltas that aren't necessarily
related to a single object, but instead, span multiple objects.

This may be useful if there are many objects in your collections that share some
property. Here's an example that calculates a Delta of Pokemon types:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  keys: [:type],
  pluck: [:type]
)

delta.additions.to_a
#=> []

delta.modifications.to_a
#=> []

delta.deletions.to_a
#=> [#<struct type="Water">]
```

In this example, both 'Electric' and 'Flying' types remain in the collection.
The only difference is the deletion of all 'Water' type Pokemon as a result of
removing 'Magikarp' from the collection.

## Contribution

Thanks for the using this gem. If you think of a great new feature or you find a
problem, please open an issue or a pull request and I'll try to get back to you.
