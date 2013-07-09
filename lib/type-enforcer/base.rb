module TypeEnforcer
  class Error < StandardError; end
  class NotFulfilledError < Error; end
  class NotPresentError < Error; end

  refine Object do
    def enforce(*args, &block)
      if block_given?
        if try(*args, &block)
          self
        else
          nil
        end
      else
        case type = args.first
        when Symbol
          if TypeEnforcer.try(type, self, *args[1..-1]) || try(*args)
            self
          else
            nil
          end
        else
          if self.acts_as?(type)
            self.try(:convert_to, *args) || self
          else
            nil
          end
        end
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

    def try(*args)
      options = TypeEnforcer.build_options(args, rescues: StandardError)
      begin
        if block_given?
          yield(self, *args)
        else
          send(*args)
        end
      rescue options[:rescues]
        nil
      end
    end

    def blank?
      nil? || try(:empty?)
    end
  end

  def self.build_options(options, defaults)
    if options.is_a?(Array)
      options = options.last.is_a?(Hash) ? options.pop : {}
    end

    defaults.merge(options)
  end
end