# HungarianAlgorithm

Ruby implementation of the [hungarian algorithm](https://en.wikipedia.org/wiki/Hungarian_algorithm).

Follow the Hungarian (or Kuhn-Munkres) algorithm steps described [here](https://users.cs.duke.edu/~brd/Teaching/Bio/asmb/current/Handouts/munkres.html).

## Installation

Add this line to your application's Gemfile: `gem 'hungarian_algorithm'`

And then execute: `$ bundle`

Or install it yourself as: `$ gem install hungarian_algorithm`

## Usage

Create an array of arrays and execute the algo.

Example :
```ruby
HungarianAlgorithm.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]]).process
=> [[0, 2], [1, 1], [2, 0]]
```

It returns the matrix coordinates of the assignments.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sybil/hungarian_algorithm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the GNU GENERAL PUBLIC LICENSE 3.0.

## Code of Conduct

Everyone interacting in the HungarianAlgorithm project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sybil/hungarian_algorithm/blob/master/CODE_OF_CONDUCT.md).
