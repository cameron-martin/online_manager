# OnlineManager

Manage whether users are online when you have a regular heartbeat, coming from a websocket for example.
It allows you to have frequent heartbeats, but you only update the user's status when they transition between online and offline states.
I have not run any benchmarks, but this is probably faster than updating your database every few seconds with a last_online timestamp.

It runs in an eventmachine reactor, and defines a simple DSL with callbacks which are executed when a user transitions between online and offline states.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'online_manager'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install online_manager

## Usage

```ruby
require 'online_manager'

# You should set all the users offline when it first runs,
# since otherwise you'll be left with users marked online from when it last quit.

class OnlineConfig

  # How long since a heartbeat was last received until the user is considered offline? (in seconds)
  def timeout
    5
  end

  # All the blocks below will be called inside an eventmachine reactor.

  def setup
    # Set up any websocket server/connection to pubsub server, etc
    # This must use eventmachine, otherwise it will block the reactor.
    # Then yield(user_id) whenever you receive a heartbeat from a user.
  end

  def online(user_id)
    puts "Booster #{user_id} online"
    # Update the user to online in the database or whatever
    # This must use asynchronous i/o, otherwise it will block the reactor.
  end

  def offline(user_id)
    puts "Booster #{user_id} offline"
    # Called when a user transitions from online -> offline
  end
end

# This runs an eventmachine reactor, so the call to .run blocks.
OnlineManager.run(OnlineConfig.new)
```

If you already are in the context of an eventmachine reactor, or you want to run multiple of these in the same thread,
you can use `.setup`.

```ruby
EM.run do
  OnlineManager.setup(OnlineConfig.new)
end
```

## TODO

* Write tests for this. Its pretty simple (~ 50 lines of code) and I have it running in production, so it should be fine.
  Check out [this][1] for testing eventmachine.
* Consider setting remaining users offline in an ensure block, so it always leaves the statuses in a consistent state.
  [Could this replace setting users offline on initialization?][2]

## Contributing

1. Fork it ( https://github.com/cameron-martin/online_manager/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


[1]: https://github.com/jcoglan/rspec-eventmachine
[2]: http://stackoverflow.com/questions/25235089/when-will-rubys-ensure-not-run