# -*- frozen_string_literal: true -*-

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'rsplit'

class MyString < String # :nodoc:
end
