module TypeEnforcer
  class Error < StandardError; end
  class NotFulfilledError < Error; end
  class NotPresentError < Error; end

  refine Object do
    def enforce(*args, &block)
      options = TypeEnforcer.build_options(args, error: nil)

      if block_given?
        if try(*args, &block)
          self
        else
          TypeEnforcer.raise_or_return(options[:error])
        end
      else
        case type = args.first
        when Symbol
          if TypeEnforcer.try(type, self, *args[1..-1]) || try(*args)
            self
          else
            TypeEnforcer.raise_or_return(options[:error])
          end
        else
          if self.acts_as?(type)
            self.try(:convert_to, *args) || self
          else
            TypeEnforcer.raise_or_return(options[:error])
          end
        end
      end
    end
    alias_method :e, :enforce

    def enforce!(*args, &block)
      enforce(*args, {error: NotFulfilledError}, &block)
    end
    alias_method :e!, :enforce!

    def acts_as?(type)
      type === self
    end

    def present?
      !nil?
    end

    def present!(error: NotPresentError)
      unless present?
        TypeEnforcer.raise_or_return(error)
      else
        self
      end
    end
    alias_method :p!, :present!

    def try(*args)
      options = TypeEnforcer.build_options(args, rescues: StandardError, error: nil)
      # (block_given? ? yield(self, *args) : send(*args)) rescue nil
      begin
        if block_given?
          yield(self, *args)
        else
          send(*args)
        end
      rescue options[:rescues] || StandardError
        TypeEnforcer.raise_or_return(options[:error])
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

  def self.raise_or_return(error)
    if error.is_a?(Class) && error <= Exception
      raise error
    else
      error
    end
  end
end