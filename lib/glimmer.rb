# Glimmer - a JRuby DSL that enables easy and efficient authoring of user
# interfaces using the robust platform-independent Eclipse SWT library. Glimmer
# comes with built-in data-binding support to greatly facilitate synchronizing
# UI with domain models.
require 'logger'
require 'set'

# Glimmer provides a JRuby Desktop UI DSL + Data-Binding functionality
#
# A desktop UI application class must include Glimmer to gain access to Glimmer DSL
#
# Glimmer DSL static keywords (e.g. rgb, bind, etc..) are available as inherited methods
# Glimmer DSL dynamic keywords (e.g. label, combo, etc...) are available via method_missing
module Glimmer
  #TODO make it configurable to include or not include perhaps reverting to using included
  REGEX_METHODS_EXCLUDED = /^(to_|\[)/

  def method_missing(method_symbol, *args, &block)
    # This if statement speeds up Glimmer in girb or whenever directly including on main object
    if method_symbol.to_s.match(REGEX_METHODS_EXCLUDED)
      raise InvalidKeywordError, "Glimmer excluded keyword: #{method_symbol}"
    end
    Glimmer::Config.logger&.debug "Interpreting keyword: #{method_symbol}"
    Glimmer::DSL::Engine.interpret(method_symbol, *args, &block)
  rescue InvalidKeywordError => e
    if !method_symbol.to_s.match(REGEX_METHODS_EXCLUDED)
      Glimmer::Config.logger&.error e.message
    end
    Glimmer::Config.logger&.debug "#{e.message}\n#{e.backtrace.join("\n")}"
    super(method_symbol, *args, &block)
  end
end

$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'glimmer/config'
require 'glimmer/error'
require 'glimmer/invalid_keyword_error'
require 'glimmer/dsl/engine'
