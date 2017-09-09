# Poland (concept)

A pattern for contexts in ruby applications

## Description

Poland is a toolkit encouraging simple code written in testable ruby.

## Thoughtdump

### Apps `Poland::Context`

```rb
module Comments
  class Context < Poland::Context
    register_commands Commands::AddComment, Commands::RemoveComment
    register_queries Queries::GetComments, Queries::GetComment

    config do |config|
      config.something = 'somethingelse'
    end

    container do | container |
      container.factory :add_comment do |container|
        Comments::AddComment.new(app[:comments_repository])
      end

      container.singleton :comments_repository, Comments::Repository
    end
  end
end

module Comments
  class AddComment
    attr_reader :comments_repository

    def initialize(comments_repository)
      @comments_repository = comments_repository
    end

    def perform(params)
      #Do some work
    end
  end
end

module Comments
  class GetComment
    attr_reader :comments_repository

    def initialize(comments_repository)
      @comments_repository = comments_repository
    end

    def fetch(comment_id)
      result = comments_repository.fetch(id)
      Dry::Monads::Maybe.bind(result)
    end
  end
end
```

### Inversion of Control `Poland::IOC`

```rb
class Service
  def initialize
    puts "Initialized"
  end
end

container = Poland::IOC::Container.new

container.bind :service do |container|
  Service.new
end

container.factory :service2 do |container|
  Service.new
end

container.instance :service3, Service.new
=> Initialized

container[:service]
=> Initialized
container[:service]

container[:service2]
=> Initialized
container[:service2]
=> Initialized

container[:service3]
```

## Installation (TODO)

Add this line to your application's Gemfile:

```ruby
gem 'poland'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install poland

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/poland.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
