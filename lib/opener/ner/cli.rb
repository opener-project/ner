module Opener
  class Ner
    ##
    # CLI wrapper around {Opener::Ner} using Slop.
    #
    # @!attribute [r] parser
    #  @return [Slop]
    #
    class CLI
      attr_reader :parser

      def initialize
        @parser = configure_slop
      end

      ##
      # @param [Array] argv
      #
      def run(argv = ARGV)
        parser.parse(argv)
      end

      ##
      # @return [Slop]
      #
      def configure_slop
        return Slop.new(:strict => false, :indent => 2, :help => true) do
          banner 'Usage: ner [OPTIONS]'

          separator <<-EOF.chomp

About:

    Named Entity Recognition for various languages such as English and Dutch.
    This command reads input from STDIN.

Example:

    cat some_file.kaf | ner
          EOF

          separator "\nOptions:\n"

          on :v, :version, 'Shows the current version' do
            abort "ner v#{VERSION} on #{RUBY_DESCRIPTION}"
          end

          on :l=, :language=, 'Sets a specific language to use', :as => String

          run do |opts, args|
            parser = Ner.new(
              :args     => args,
              :language => opts[:language]
            )

            input = STDIN.tty? ? nil : STDIN.read

            puts parser.run(input)
          end
        end
      end
    end # CLI
  end # ConstituentParser
end # Opener
