require File.dirname(__FILE__) + "/../command_handler"
require File.dirname(__FILE__) + "/models/g_widget"

class WidgetListenerCommandHandler
  include CommandHandler
  
  include_package 'org.eclipse.swt.widgets'

  def can_handle?(parent, command_symbol, *args, &block)
    Glimmer.logger.debug "parent is a widget: " + (parent.is_a?(GWidget)).to_s
    return unless parent.is_a?(GWidget)
    Glimmer.logger.debug "on listener?: " + (command_symbol.to_s[0,3] == "on_").to_s
    return unless command_symbol.to_s[0,3] == "on_"
    Glimmer.logger.debug "command symbol is longer than 3: " + (command_symbol.to_s.length > 3).to_s
    return unless command_symbol.to_s.length > 3
    Glimmer.logger.debug "args are 0?: " + (args.size == 0).to_s
    return unless args.size == 0
    Glimmer.logger.debug "can add listener? " + (parent.can_add_listener?(command_symbol.to_s[3, command_symbol.to_s.length])).to_s
    parent.can_add_listener?(command_symbol.to_s[3, command_symbol.to_s.length])
  end
  
  def do_handle(parent, command_symbol, *args, &block)
    parent.add_listener(command_symbol.to_s[3, command_symbol.to_s.length], &block)
    ListenerParent.new #TODO refactor and move to models
  end
  
  #TODO refactor and move to separate file
  class ListenerParent
      include Parent
      
    def process_block(block)
      #NOOP
    end
    
  end
  
end