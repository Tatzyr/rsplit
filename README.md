# rsplit

Divides string into substrings based on a delimiter (starting from right),
returning an array of these substrings.

```ruby
"1.2.3".split(".", 2)     #=> ["1", "2.3"]
"1.2.3".rsplit(".", 2)    #=> ["1.2", "3"]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rsplit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rsplit

## Usage

```ruby
require "rsplit"

" now's  the time".rsplit        #=> ["now's", "the", "time"]
" now's  the time".rsplit(" ")   #=> ["now's", "the", "time"]

"mellow yellow".rsplit("ello")   #=> ["m", "w y", "w"]
"..1.2..3.4".rsplit(".")         #=> ["1", "2", "", "3", "4"]
"..1.2..3.4".rsplit(".", 4)      #=> ["..1.2", "", "3", "4"]
"..1.2..3.4".rsplit(".", -1)     #=> ["", "", "1", "2", "", "3", "4"]

"".rsplit(".")                   #=> []
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Tatzyr/rsplit.
