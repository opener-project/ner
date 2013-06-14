require 'optparse'
require 'opener/ners/base'
require 'opener/ners/fr'

require_relative 'ner/version'
require_relative 'ner/cli'

module Opener
  ##
  # Primary NER class that takes care of delegating NER actions to the language
  # specific kernels.
  #
  # @!attribute [r] options
  #  @return [Hash]
  #
  class Ner
    attr_reader :options

    ##
    # The default language to use when no custom one is specified.
    #
    # @return [String]
    #
    DEFAULT_LANGUAGE = 'en'.freeze

    ##
    # Hash containing the default options to use.
    #
    # @return [Hash]
    #
    DEFAULT_OPTIONS = {
      :args     => [],
      :language => DEFAULT_LANGUAGE
    }.freeze

    ##
    # @param [Hash] options
    #
    # @option options [Array] :args Collection of arbitrary arguments to pass
    #  to the underlying kernels.
    # @option options [String] :language The language to use.
    #
    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end

    ##
    # Processes the input and returns an array containing the output of STDOUT,
    # STDERR and an object containing process information.
    #
    # @param [String] input
    # @return [Array]
    #
    def run(input)
      args = options[:args].dup

      if language_constant_defined?
        kernel = language_constant.new(:args => args)
      else
        kernel = Ners::Base.new(:args => args, :language => options[:language])
      end

      return kernel.run(input)
    end

    protected

    ##
    # Returns `true` if the current language has a dedicated kernel class.
    #
    # @return [TrueClass|FalseClass]
    #
    def language_constant_defined?
      return Ners.const_defined?(language_constant_name)
    end

    ##
    # @return [String]
    #
    def language_constant_name
      return options[:language].upcase
    end

    ##
    # @return [Class]
    #
    def language_constant
      return Ners.const_get(language_constant_name)
    end
  end # Ner
end # Opener
