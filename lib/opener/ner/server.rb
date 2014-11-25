require 'opener/webservice'

module Opener
  class Ner
    ##
    # NER server powered by Sinatra.
    #
    class Server < Webservice::Server
      set :views, File.expand_path('../views', __FILE__)

      self.text_processor  = Ner
      self.accepted_params = [:input]
    end # Server
  end # Ner
end # Opener
