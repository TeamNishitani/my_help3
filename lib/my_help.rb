# frozen_string_literal: true

require_relative "my_help/version"
require_relative "my_help/list"
require_relative "my_help/config"

module MyHelp
  class Error < StandardError; end

  # Your code goes here...
  class Modify
    def initialize(path = "", ext = ".org")
      @path = path
      @ext = ext
    end

    def new(help_name)
      # argument => 引数
      # verbose => 饒舌（おしゃべりな）
      target = File.join(@path, help_name + @ext)
      source = File.join(@path, "example.org")
      FileUtils.cp(source, target, verbose: false)
    end

    def delete(help_name)
      target = File.join(@path, help_name + @ext)
      FileUtils.rm(target, verbose: false)
    end

    def edit(help_name)
      target = File.join(@path, help_name + @ext)
      system("emacs #{target}")
    end
  end
end
