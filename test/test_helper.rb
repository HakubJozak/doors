$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "rubygems"
require "bundler"

Bundler.setup(:default, :test)

require "doors"
require "minitest/autorun"
