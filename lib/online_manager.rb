require 'eventmachine'

require 'online_manager/dsl'

class OnlineManager
  attr_writer :online_callback, :offline_callback, :setup_callback, :timeout

  def self.run(*args, &block)
    new(*args, &block).run
  end

  def self.setup(*args, &block)
    new(*args, &block).setup
  end

  def initialize
    @timeout = nil
    @online_users = {}
    @online_callback = -> (_) {  }
    @offline_callback = -> (_) {  }
    @setup_callback = ->(_) { raise 'You must specify a setup callback' }

    yield DSL.new(self) if block_given?

    raise 'Timeout must be specified' unless @timeout
  end

  def run
    EM.run { setup }
  end

  def setup
    @setup_callback.call(method(:seen))
  end

private

  def seen(id)
    @online_callback.call(id) unless online?(id)

    time = Time.now
    @online_users[id] = time

    EM.add_timer(@timeout) do
      set_offline(id, time)
    end
  end

  def set_offline(id, time)
    if @online_users[id] == time
      @online_users.delete(id)
      @offline_callback.call(id)
    end
  end

  def online?(id)
    @online_users.has_key?(id)
  end
end