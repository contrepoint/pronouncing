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

      File.open(dictionary, 'r').each do |line|
        unless is_comment?(line)
          word, phones = line.strip.split("  ")
          formatted_word = format_word(word)
          add_to_rhymes_dict(formatted_word, phones)
          add_to_words_dict(formatted_word, phones)
        end
      end
    end

    def phones(word)
      word = clean_word(word)
      @words[word][:phones]
    end

    def stresses(word)
      word = clean_word(word)
      @words[word][:stresses]
    end

    def syllables(word)
      word = clean_word(word)
      @words[word][:syllables]
    end

    def rhyming_parts(word)
      all_pronunciations = phones(word)

      all_pronunciations.map do |phones|
        rhyming_part(phones)
      end
    end

    def rhymes_for(word)
      word = clean_word(word)
      @words[word][:rhyming_parts].map{ |rp| @rhymes[rp] }.flatten
    end

    def rhymes?(word_1, word_2)
      word_1 = clean_word(word_1)
      word_2 = clean_word(word_2)
      return true if word_1 == word_2

      rhymes_for(word_1).include?(word_2)
    end

    private

    def is_comment?(line)
      line.start_with?(';;;')
    end

    def format_word(word)
      return word if word[0] == '('

      word.downcase.split("(")[0]
    end

    def clean_word(word)
      word.strip.downcase
    end

    def add_to_words_dict(word, phones)
      add_phones(word, phones)
      add_stresses(word, phones)
      add_syllable_count(word, phones)
      add_rhyming_part(word, phones)
    end

    def add_phones(word, phones)
      @words[word][:phones] << phones
    end

    def add_stresses(word, phones)
      stresses = phones.gsub(/[^012]/, '')
      @words[word][:stresses] << stresses
    end

    def add_syllable_count(word, phones)
      syllable_count = phones.gsub(/[^012]/, '').length
      @words[word][:syllables] << syllable_count
    end

    def add_rhyming_part(word, phones)
      rhyming_part = rhyming_part(phones)
      @words[word][:rhyming_parts] << rhyming_part
    end

    def rhyming_part(phones)
      phones = phones.split().reverse
      phones.each_with_index do |p, idx|
        if "12".include?(p[-1])
          return phones[0..idx].reverse.join(' ')
        end
      end
    end

    def add_to_rhymes_dict(word, phones)
      rhyming_part = rhyming_part(phones)
      @rhymes[rhyming_part] += [word]
    end
  end
end
