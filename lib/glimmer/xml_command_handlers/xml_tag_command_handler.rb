require "facets"
require File.dirname(__FILE__) + "/../command_handler"
require File.dirname(__FILE__) + "/models/node"

module Glimmer
  class XmlTagCommandHandler
    include CommandHandler

    def can_handle?(parent, command_symbol, *args, &block)
      (parent == nil or parent.is_a?(Node)) and
      (command_symbol.to_s == "tag") and
      ((args.size == 1) and ((args[0].is_a?(Hash)) or (args[0].is_a?(Hash)))) and
      args[0].include?(:_name)
    end

    def do_handle(parent, command_symbol, *args, &block)
      attributes = nil
      attributes = args[0] if (args.size == 1)
      tag_name = attributes[:_name]
      attributes.delete(:_name)
      Node.new(parent, tag_name, attributes, &block)
    end

  end
end
