# -*- encoding : utf-8 -*-
require "warning_cleaner/rule"
module WarningCleaner
  def self.configure(&block)
    yield @config ||= WarningCleaner::Config.new(Rule.new("4.2.11.1"))
  end

  class Config

    attr_accessor :rule, :is_open

    def initialize(rule, is_open = true)
      @rule = rule
      @is_open = is_open
      clean_warning! if is_open
    end

    def clean_warning!
      rule.run!
    end

  end
end

