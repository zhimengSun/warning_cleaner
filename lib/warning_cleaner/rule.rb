# -*- encoding : utf-8 -*-
module WarningCleaner

  if RUBY_VERSION >= '2.4'
    require 'bigdecimal'
  
    def BigDecimal.new(*args, **kwargs)
      BigDecimal(*args, **kwargs)
    end

    unless defined?(Fixnum)
      Fixnum = Class.new(Integer) 
    end

    unless defined?(Bignum)
      Bignum = Class.new(Integer) 
    end

  else
    # future features
  end
      
  class Rule

    WHITE_KEYS = %i(
      rails_version
      skip_line_contain
    )

    DEFAULT_SKIP_WORDS = [ 
      "already initialized constant",
      "previous definition of",
      "Fixnum is deprecated",
      "Bignum is deprecated",
      "defined at the refinement"
    ].freeze

    attr_accessor *WHITE_KEYS
    def initialize(rails_version, skip_line_contain = [])
      @rails_version = rails_version
      @skip_line_contain = DEFAULT_SKIP_WORDS + skip_line_contain
    end

    def run!
      rule = self
      if defined?(::Warning)
        ::Warning.instance_eval do
          alias_method :warn2, :warn
          remove_method :warn

          define_method(:warn) do |str|
            unless str =~ /#{rule.instance_variable_get("@skip_line_contain").join("|")}/
              warn2 str
            end
          end
        end
      end
    end

  end
end

