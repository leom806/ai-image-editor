# frozen_string_literal: true

#
# A ServiceObject is a class that encapsulates a single business process.
#
# This service will make sure all methods from a service are private to that
# class to ensure encapsulation and the only way to execute that service will
# be via its public interface (call method).
#
module ServiceObject
  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Class methods that will be included
  #
  module ClassMethods
    def call(...)
      send(:new, ...).send(:call)
    end
  end

  private_methods instance_methods(false)
end
