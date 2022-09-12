# frozen_string_literal: true
require "thor"
require "fileutils"
require "pp"
require "yaml"
require_relative "my_help/version"
require_relative "my_help/list"
require_relative "my_help/config"
require_relative "my_help/modify"
require_relative "my_help/init"
require_relative "my_help/cli"

module MyHelp
  class Error < StandardError; end

  # Your code goes here...
  # get org and trans it to hash by FSM
  class Org2Hash
    attr_accessor :contents, :text
    # current   new_state   action
    TRANSITIONS = {
      :header_read => {
        "* " => [:contents_read, :start_new_item],
        :default => [:header_read, :ignore],
      },
      :contents_read => {
        "* " => [:contents_read, :start_new_item],
        :default => [:contents_read, :add_contents],
      },
    }

    def initialize(org_text)
      @text = org_text
      @contents = Hash.new
      simple_fsm()
    end

    def simple_fsm()
      state = :header_read
      item = ""
      @text.split("\n").each do |line|
        next if line.size < 1
        state, action = TRANSITIONS[state][line[0..1]] ||
                        TRANSITIONS[state][:default]
        case action
        when :ignore
        when :start_new_item
          item = read_item(line)
          @contents[item] = ""
        when :add_contents
          @contents[item] += line + "\n"
        end
      end
    end

    def read_item(line)
      line.match(/\* (.+)/)[1]
    end
  end
end
