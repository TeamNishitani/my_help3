# frozen_string_literal: true

require_relative "my_help/version"
require_relative "my_help/list"
require_relative "my_help/config"
require_relative "my_help/modify"
require_relative "my_help/init"

require "thor"

module MyHelp
  class Error < StandardError; end

  # Your code goes here...
  class CLI < Thor
    desc "version", "show version"

    def version
      #invoke :setup
      puts VERSION
    end
  end
end
