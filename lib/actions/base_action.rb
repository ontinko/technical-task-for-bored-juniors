# frozen_string_literal: true

class BaseAction
  def self.call(args)
    instance = new(args)
    instance.call
  end

  def initialize(args)
    @args = args
  end

  def call
    raise NotImplementedError
  end
end
