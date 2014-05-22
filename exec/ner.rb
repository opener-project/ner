#!/usr/bin/env ruby

require 'opener/daemons'
require_relative '../lib/opener/ner'

options = Opener::Daemons::OptParser.parse!(ARGV)
daemon  = Opener::Daemons::Daemon.new(Opener::Ner, options)

daemon.start