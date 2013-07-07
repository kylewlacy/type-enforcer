module TypeEnforcer
  refine String do
    def numeric?
      (/^\d+(\.\d+)?$/ =~ self).present?
    end

    def fixnum?
      (/^\d+$/ =~ self).present?
    end

    def blank?
      (/^\s*$/ =~ self).present?
    end
  end

  refine Numeric do
    # http://stackoverflow.com/a/1093707/1311454
    def whole?
      self % 1 == 0
    end
  end
end