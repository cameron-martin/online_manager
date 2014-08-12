require 'eventmachine'

class OnlineManager
  def self.run(*args, &block)
    new(*args, &block).run
  end

  def self.setup(*args, &block)
    new(*args, &block).setup
  end

  def initialize(config)
    @config = config
    @online_users = {}
  end

  def run
    EM.run { setup }
  end

  def setup
    @config.setup(&method(:seen))
  end

private

  def seen(id)
    @config.online(id) unless online?(id)

    time = Time.now
    @online_users[id] = time

    EM.add_timer(@config.timeout) do
      set_offline(id, time)
    end
  end

  def set_offline(id, time)
    if @online_users[id] == time
      @online_users.delete(id)
      @config.offline(id)
    end
  end

  def online?(id)
    @online_users.has_key?(id)
  end
end