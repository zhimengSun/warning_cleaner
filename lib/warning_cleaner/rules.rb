# -*- encoding : utf-8 -*-
module WarningCleaner
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

    attr_accessor WHITE_KEYS.keys
    def initialize(rails_version, skip_line_contain = [])
      @rails_version = rails_version
      @skip_line_contain = DEFAULT_SKIP_WORDS + skip_line_contain
    end

    def run!
      if RUBY_VERSION >= '2.4'
        require 'bigdecimal'
      
        def BigDecimal.new(*args, **kwargs)
          BigDecimal(*args, **kwargs)
        end

        Fixnum = Class.new(Integer) unless defined?(Fixnum)
        Bignum = Class.new(Integer) unless defined?(Bignum)

      else
        # future features
      end
      
      Warning.instance_eval do
        define_method :warn do |warn|
          _warn =~ /#{@rule.skip_line_contain.join("|")}/ and return
          super(_warn)
        end
      end
    end

  end
end

