require "pronouncing/version"

module Pronouncing
  class Dictionary
    def initialize(dictionary = nil)
      dictionary ||= File.join(File.dirname(__FILE__), "/dictionary/cmudict-0.7b.txt")

      @rhymes = Hash.new{ |hash, key| hash[key] = [] }
      @words = Hash.new do |hash, key|
        hash[key] = {
          phones: [], stresses: [], syllables: [], rhyming_parts: []
        }
      end
    end
  end
end
