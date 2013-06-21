require 'sinatra/base'
require 'httpclient'

module Opener
  class Ner
    ##
    # NER server powered by Sinatra.
    #
    class Server < Sinatra::Base
      configure do
        enable :logging
      end

      configure :development do
        set :raise_errors, true
        set :dump_errors, true
      end

      ##
      # Presents a simple form that can be used for getting the NER of a KAF
      # document.
      #
      get '/' do
        erb :index
      end

      ##
      # Gets the NER of a KAF document.
      #
      # @param [Hash] params The POST parameters.
      #
      # @option params [String] :text The KAF to process.
      # @option params [String] :language The language to use.
      # @option params [Array<String>] :callbacks A collection of callback URLs
      #  that act as a chain. The results are posted to the first URL which is
      #  then shifted of the list.
      # @option params [String] :error_callback Callback URL to send errors to
      #  when using the asynchronous setup.
      #
      post '/' do
        if !params[:text] or params[:text].strip.empty?
          logger.error('Failed to process the request: no KAF specified')

          halt(400, 'No KAF specified')
        end

        callbacks = extract_callbacks(params[:callbacks])
        
        if callbacks.empty?
          process_sync
        else
          process_async(callbacks)
        end
      end


      ##
      # Processes the request synchronously.
      #
      def process_sync
        output = calculate_ner(params[:text], params[:language])

        content_type(:xml)

        body(output)
      rescue => error
        logger.error("Failed to tag the text: #{error.inspect}")

        halt(500, error.message)
      end

      ##
      # Processes the request asynchronously.
      #
      # @param [Array] callbacks The callback URLs to use.
      #
      def process_async(callbacks)
        Thread.new do
          calculate_ner_async(params[:text], callbacks, params[:error_callback])
        end

        status(202)
      end

      ##
      # Gets the NER of a KAF document.
      #
      # @param [String] text The KAF to tokenize.
      # @param [String] language The language of the KAF document.
      # @return [String]
      # @raise RunetimeError Raised when the tagging process failed.
      #
      def calculate_ner(text)
        tagger                = Ner.new
        output, error, status = tagger.run(text)

        raise(error) unless status.success?

        return output
      end

      ##
      # Gets the NER of a KAF document and submits it to a callback URL.
      #
      # @param [String] text
      # @param [Array] callbacks
      # @param [String] error_callback
      #
      def calculate_ner_async(text, callbacks, error_callback = nil)
        begin
          output = calculate_ner(text)
        rescue => error
          logger.error("Failed to calculate ner: #{error.inspect}")

          submit_error(error_callback, error.message) if error_callback
        end

        url = callbacks.shift

        logger.info("Submitting results to #{url}")

        begin
          process_callback(url, output, callbacks)
        rescue => error
          logger.error("Failed to submit the results: #{error.inspect}")

          submit_error(error_callback, error.message) if error_callback
        end
      end

      ##
      # @param [String] url
      # @param [String] text
      # @param [Array] callbacks
      #
      def process_callback(url, text, callbacks)
        HTTPClient.post(
          url,
          :body => {:text => text, :'callbacks[]' => callbacks, :kaf => true}
        )
      end

      ##
      # @param [String] url
      # @param [String] message
      #
      def submit_error(url, message)
        HTTPClient.post(url, :body => {:error => message})
      end
      
      ##
      # Returns an Array containing the callback URLs, ignoring empty values.
      #
      # @param [Array|String] input
      # @return [Array]
      #
      def extract_callbacks(input)
        callbacks = input.compact.reject(&:empty?)

        return callbacks
      end
    end # Server
  end # Ner
end # Opener
