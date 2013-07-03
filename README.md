# DataMapped

Ruby mixins for [DataMapper](http://datamapper.org/).



## Installation

Add this line to your application's Gemfile:

    gem 'data_mapped'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data_mapped



## Usage

### Normal Model

This mixin sets up your class for DataMapper, and adds `id`, `created_at`, and
`updated_at` properties that behave as expected.

TODO: Write usage instructions here

### Join Model (for a Join Table)

This mixin sets up your class for DataMapper, and adds `created_at` and
`updated_at` properties that behave as expected.  This join model differs from
the normal model (above) in that the join model doesn't add an `id` property,
as it expects for your class to define a composite primary key using
`belongs_to` properties.

TODO: Write usage instructions here

### Permanent Model (that Can't be Destroyed)

This mixin prevents resources of your class from being destroyed (at least in
the typical fashion using `#destroy`).  It's meant to be used in conjunction
with either the normal model or the join model mixin (above).

TODO: Write usage instructions here

### Searchable Model

This mixin duct tapes your class together with
[Sunspot](http://sunspot.github.io/) and
[Solr](https://lucene.apache.org/solr/), and makes your class's resources
indexed and searchable.

TODO: Write usage instructions here



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
