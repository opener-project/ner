module Opener
  class Ner
    ##
    # Configures the CLI options for the primary NER class.
    #
    # @!attribute [r] options
    #  @return [Hash]
    # @!attribute [r] parser
    #  @return [OptionParser]
    #
    class OptionParser
      attr_reader :options, :parser

      def initialize
        @options = default_options
        @parser  = ::OptionParser.new do |opts|
          opts.banner = 'Usage: cat file.kaf | ner [OPTIONS]'

          opts.on('-h', '--help', 'Shows this help message') do
            show_help
          end

          opts.on('-v', '--version', 'Shows the version') do
            puts("ner v#{VERSION} #{RUBY_DESCRIPTION}")
            exit
          end

          opts.on(
            '-l',
            '--language [VALUE]',
            'The language to use',
            String
          ) do |value|
            @options[:language] = value
          end
        end
      end

      ##
      # @see OptionParser#parse
      #
      def parse(*args)
        return parser.parse(*args)
      end

      ##
      # Shows the help message and aborts.
      #
      def show_help
        abort parser.to_s
      end

      ##
      # @return [Hash]
      #
      def default_options
        return {:language => 'en'}
      end
    end # OptionParser
  end # Ner
end # Opener
