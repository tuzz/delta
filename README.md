## Delta

[![Build Status](https://travis-ci.org/tuzz/delta.svg?branch=master)](https://travis-ci.org/tuzz/delta)

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
  #<Pokemon @species="Raichu", @name="Zappy", @type="Electric">,
  #<Pokemon @species="Butterfree", @name="Flappy", @type="Flying">
]

delta.deletions.to_a
#=> [
  #<Pokemon @species="Pikachu", @name="Zappy", @type="Electric">,
  #<Pokemon @species="Magikarp", @name="Splashy", @type="Water">
]
```

## Pluck

Sometimes, you'll only be interested in a few of the attributes on an object.
Delta supports `pluck`, which selects only the attributes you're interested in,
instead of returning full objects:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  pluck: [:name, :species]
)

delta.additions.to_a
#=> [
  #<struct name="Zappy", species="Pikachu">,
  #<struct name="Flappy", species="Butterfree">
]

delta.deletions.to_a
#=> [
  #<struct name="Zappy", species="Raichu">,
  #<struct name="Splashy", species="Magikarp">
]
```

## Modifications

In most cases, it is more appropriate to think in terms of modifications rather
than additions and deletions. In the example above, 'Pikachu' appeared as a
deletion and 'Raichu' appeared as an addition. It might make more sense to model
this as a modification, i.e. 'Zappy' changing its 'species'.

Delta supports setting the `keys` that uniquely identify each object in the
collection:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  pluck: [:species, :name],
  keys: [:name]
)

delta.additions.to_a
#=> [#<struct species="Butterfree", name="Flappy">]

delta.modifications.to_a
#=> [#<struct species="Raichu", name="Zappy">]

delta.deletions.to_a
#=> [#<struct species="Magikarp", name="Splashy">]
```

You should specify which attributes to `pluck` so that Delta can distinguish
between objects that have changed and objects that have not changed, but appear
in both collections.

If you do not specifiy any attributes to `pluck`, Delta will fall back to using
object equality to determine which objects have changed. For ActiveRecord
relations, Delta will use the database id as its fall back as it is more
performant to do so.

## Composite Keys

In some cases, objects will be uniquely identified by a combination of things.
For example, consider an application that enforces the uniqueness of names, but
only in the context of a 'type'. This would mean that two Pokemon can have the
same name, as long as they are not of the same type (e.g. 'Water').

In these cases, you can specify multiple keys:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  pluck: [:species, :name, :type],
  keys: [:name, :type] # <--
)

delta.additions.to_a
#=> [#<struct species="Butterfree", name="FANG!", type="Flying">]

delta.modifications.to_a
#=> [#<struct species="Raichu", name="Zappy", type="Electric">]

delta.deletions.to_a
#=> [#<struct species="Magikarp", name="FANG!", type="Water">]
```

Consider the alternative where 'name' is used as the only key. This would mean
that the Pokemon with species' 'Butterfree' and 'Magikarp' would be considered
the same. This is semantically incorrect for this particular domain.

## Many-to-one Deltas

By combining the use of `pluck` and `keys`, you can build deltas that aren't
necessarily related to a single object, but instead span multiple objects within
the collection.

This may be useful if there are objects in your collections that share some
property. In this example, all of the Pokemon have a 'type'. We can build a
Delta that shows the difference in types between collections, like so:

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

In this example, both 'Electric' and 'Flying' types appear in both collections.
The only difference is the deletion of all 'Water' type Pokemon as a result of
removing 'Magikarp' from the first collection.

## Rails Support

Delta has added support for Rails applications. If the given collections are of
class ActiveRecord::Relation, Delta will try to improve performance by reducing
the number of select queries on the database. This isn't perfect and may not
work with old versions of Rails.

## In the Wild

So far, we've talked a lot about Pokemon, but how is this useful in the
real-world?

Consider an application that is backed by an external content management system.
You have some kind of extract-transform-load process that takes content from the
CMS and pushes it into your database. Your application is serving live traffic
and needs to remain available at all times.

To minimise the amount of churn on your database, it makes sense to calculate
just the things that have changed, rather than rebuilding the entire set of
content each time. To do this, you could push the CMS content into a staging
database where you calculate a Delta without touching your live application.

Once this Delta is calculated, you can then stream the minimal set of changes
to the database that backs your application.

## Contribution

Thanks for the using this gem. If you think of a great new feature or you find a
problem, please open an issue or a pull request and I'll try to get back to you.
