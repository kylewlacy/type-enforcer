module TypeEnforcer
  class Error < StandardError; end
  class NotFulfilledError < Error; end
  class NotPresentError < Error; end

  refine Object do
    def enforce(type)
      case type
      when Symbol
        TypeEnforcer.try(type, self) || try(type) ? self : nil
      else
        self.acts_as?(type) ? self.try(:convert_to, type) || self : nil
      end
    end
    alias_method :e, :enforce

    def enforce!(type)
      enforced = enforce(type)

      raise NotFulfilledError if enforced.nil?
      enforced
    end
    alias_method :e!, :enforce!

    def acts_as?(type)
      type === self
    end

    def present?
      !nil?
    end

    def present!
      raise NotPresentError unless present?
      self
    end
    alias_method :p!, :present!

    def try(method, *args)
      send(method, *args) if respond_to?(method)
    end

    def blank?
      nil? || try(:empty?)
    end
  end
end