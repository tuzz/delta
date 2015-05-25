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

## Identifiers

By default, Delta uses
[object_id](http://ruby-doc.org/core-2.2.2/Object.html#method-i-object_id) to
compare the collections. You can tell Delta to use something else by setting the
`identifiers` parameter:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  identifiers: [:name]
)

delta.additions.to_a
#=> [#<Pokemon @species="Butterfree", @name="Flappy", @type="Flying">]

delta.deletions.to_a
#=> [#<Pokemon @species="Magikarp", @name="Splashy", @type="Water">]
```

In this case, 'Raichu' and 'Pikachu' don't appear in the additions or deletions
because they share the same name and Delta thinks that they are the same object.

## Modifications

In most cases, it is more appropriate to think in terms of modifications rather
than additions and deletions.

To calculate modifications, Delta needs to know which things might change on the
objects. You can tell Delta which things are subject to change by setting the
`changes` parameter:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  identifiers: [:name],
  changes: [:species]
)

delta.additions.to_a
#=> [#<Pokemon @species="Butterfree", @name="Flappy", @type="Flying">]

delta.modifications.to_a
#=> [#<Pokemon @species="Raichu", @name="Zappy", @type="Electric">]

delta.deletions.to_a
#=> [#<Pokemon @species="Magikarp", @name="Splashy", @type="Water">]
```

In the above example, 'Zappy' appears as a modification because Delta thinks
that 'Pikachu' and 'Raichu' are the same object because they share the same
name.

## Composite Keys

In some cases, objects will be uniquely identified by a combination of things.
For example, consider an application that enforces the uniqueness of names, but
only in the context of a 'type'.

In these cases, you can specify multiple `identifiers`:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  identifiers: [:name, :type]
  changes: [:species]
)

delta.additions.to_a
#=> [#<Pokemon @species="Butterfree", @name="FANG!", @type="Flying">]

delta.modifications.to_a
#=> [#<Pokemon @species="Raichu", @name="Zappy", @type="Electric">]

delta.deletions.to_a
#=> [#<Pokemon @species="Magikarp", @name="FANG!", @type="Water">]
```

If 'name' were the only identifier, Delta would think that 'Butterfree' and
'Magikarp' are the same object and they would not appear in additions or
deletions.

## Many to One

It is possible to build deltas that aren't necessarily related to a single
object, but instead, span multiple objects within the collections.

This may be useful if there are objects in your collection that share some
property. In this example, all of the Pokemon have a 'type'. We can build a
Delta that shows the difference in types between collections, like so:

```ruby
delta = Delta.new(
  from: [pikachu, pidgey, magikarp],
  to: [raichu, pidgey, butterfree],
  identifiers: [:type]
)

delta.additions.to_a
#=> []

delta.modifications.to_a
#=> []

delta.deletions.to_a
#=> [#<Pokemon @species="Magikarp", @name="Splashy", @type="Water">]
```

In this example, both 'Electric' and 'Flying' types appear in both collections.
The only difference is the deletion of all 'Water' type Pokemon. Note that Delta
will only return the first object that matches the deleted type.

## Rails Support

Delta has added support for Rails applications. If the collections are of class
ActiveRecord::Relation, Delta will try to improve performance by reducing the
number of select queries on the database. This may not work with old versions of
Rails.

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
