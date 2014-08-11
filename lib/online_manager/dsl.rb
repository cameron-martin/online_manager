class OnlineManager
  class DSL
    def initialize(target)
      @target = target
    end

    def timeout(timeout)
      @target.timeout = timeout
    end

    def online(&block)
      @target.online_callback = block
    end

    def offline(&block)
      @target.offline_callback = block
    end

    def setup(&block)
      @target.setup_callback = block
    end
  end
end