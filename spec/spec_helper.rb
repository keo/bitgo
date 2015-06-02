$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'bitgo'

def get_fixture(fixture)
  file = [File.dirname(__FILE__), 'fixtures', fixture].join('/')
  file = File.read(file)
  JSON.parse(file)
end
