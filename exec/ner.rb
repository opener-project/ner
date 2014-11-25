#!/usr/bin/env ruby

require 'opener/daemons'

require_relative '../lib/opener/ner'

daemon = Opener::Daemons::Daemon.new(Opener::Ner)

daemon.start
