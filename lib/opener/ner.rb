require 'optparse'
require 'opener/ners/base'
require 'opener/ners/fr'

require_relative 'ner/version'
require_relative 'ner/option_parser'

module Opener
  ##
  # Primary NER class that acts as a CLI wrapper around the various NER
  # kernels.
  #
  # @!attribute [r] args
  #  @return [Array]
  # @!attribute [r] options
  #  @return [Hash]
  # @!attribute [r] option_parser
  #  @return [Opener::Ner::OptionParser]
  #
  class Ner
    attr_reader :args, :options, :option_parser

    ##
    # @param [Hash] options
    #
    # @option options [Array] :args An array containing arguments to pass to
    #  the NER kernel.
    #
    def initialize(options = {})
      @args          = options.delete(:args) || []
      @options       = options
      @option_parser = OptionParser.new
    end

    ##
    # Tags the input and returns an Array containing the output of STDOUT,
    # STDERR and an object containing information about the executed process.
    #
    # @param [String] input
    # @return [Array]
    #
    def run(input)
      option_parser.parse(args)

      if !input or input.empty?
        option_parser.show_help
      end

      if language_constant_defined?
        kernel = language_constant.new(:args => args.dup)
      else
        kernel = Ners::Base.new(:args => args.dup, :language => language)
      end

      return kernel.run(input)
    end

    ##
    # Convenience method for tagging the input and easily handling potential
    # errors.
    #
    # @see #run
    #
    def run!(input)
      stdout, stderr, process = run(input)

      if process.success?
        puts stdout

        STDERR.puts(stderr) unless stderr.empty?
      else
        abort stderr
      end
    end

    protected

    ##
    # @return [String]
    #
    def language
      # TODO: Fix this by extracting the CLI code into a separate class.
      return options[:language] || option_parser.options[:language]
    end

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
      return language.upcase
    end

    ##
    # @return [Class]
    #
    def language_constant
      return Ners.const_get(language_constant_name)
    end
  end # Ner
end # Opener
