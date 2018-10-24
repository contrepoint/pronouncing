RSpec.describe Pronouncing::Dictionary do
  before do
    @p = Pronouncing::Dictionary.new("spec/dictionary/spec.txt")
  end

  describe "#phones" do
    context "a word with more than one pronunciation in the dict" do
      it "returns an array with multiple correct pronunciations" do
        expect(@p.phones("a")).to eq(["AH0", "EY1"])
        expect(@p.phones("extraordinary")).to eq(["EH2 K S T R AH0 AO1 R D AH0 N EH2 R IY0", "IH0 K S T R AO1 R D AH0 N EH2 R IY0"])
      end
    end

    context "a word with one pronunciation in the dict" do
      it "returns an array with one correct pronunciation" do
        expect(@p.phones("may")).to eq(["M EY1"])
      end
    end
  end

  describe "#stresses" do
    context "a word with one stress pattern" do
      it "returns an array with the one correct stress patterns" do
        expect(@p.stresses("day")).to eq(["1"])
      end
    end

    context "a word with more than one stress pattern" do
      it "returns an array with both correct stress patterns" do
        expect(@p.stresses("a")).to eq(["0", "1"])
        expect(@p.stresses("extraordinary")).to eq(["201020", "01020"])
      end
    end
  end

  describe "#rhymes?" do
    context "different surrounding whitespace" do
      context "two identical words with different capitalisation" do
        it "returns true" do
          expect(@p.rhymes?(" RUBY", "rubY ")).to be true
        end
      end

      context "two identical words with identical capitalization" do
        it "returns true" do
          expect(@p.rhymes?("ruby ", " ruby")).to be true
        end
      end

      context "given two rhyming words with different capitalisation" do
        it "returns true" do
          expect(@p.rhymes?("may ", "   DAY ")).to be true
        end
      end

      context "given two non-rhyming words with different capitalisation and different surrounding whitespace" do
        it "returns false" do
          expect(@p.rhymes?(" DaY  ", " temPeraTE  ")).to be false
        end
      end
    end

    context "identical whitespace"  do
      context "two non-rhyming words with identical capitalisation" do
        it "returns false" do
          expect(@p.rhymes?("day", "temperate")).to be false
        end
      end
    end
  end

  describe "#rhymes_for" do
    context "words in dictionary" do
      context "word with multiple pronunciations and different rhyming parts" do
        it "returns an array of rhyming words for both rhyme schemes" do
          expect(@p.rhymes_for("dove")).to eq(["dove", "love", "dove", "strove"])
        end
      end
    end

    context "words not in dictionary" do
      it "returns an empty array" do
        expect(@p.rhymes_for("ldskfj")).to be_empty
      end
    end
  end

  describe "#rhyming_parts" do
    context "words in dictionary" do
      context "multi-syllable words" do
        context "with one pronunciation" do
          it "returns an array with one rhyming part" do
            expect(@p.rhyming_parts("ruby")).to eq(['UW1 B IY0'])
          end
        end

        context "with multiple pronunciations" do
          it "returns an array with multiple different rhyming parts" do
            expect(@p.rhyming_parts("minute")).to eq(["IH1 N AH0 T", "UW1 T", "UW1 T"])
          end
        end
      end

      context "single-syllable words" do
        context "with one pronunciation" do
          it "returns an array with one rhyming part" do
            expect(@p.rhyming_parts("love")).to eq(["AH1 V"])
          end
        end

        context "with multiple pronunciations" do
          it "returns an array with multiple different rhyming parts" do
            expect(@p.rhyming_parts("dove")).to eq(["AH1 V", "OW1 V"])
          end
        end
      end
    end

    context "words not in dictionary" do
      it "returns an empty array" do
        expect(@p.rhyming_parts("ldskfj")).to be_empty
      end
    end
  end

  describe "#syllables" do
    context "words with different pronunciations" do
      context "with different syllable counts" do
        it "returns an array with multiple different syllable counts" do
        expect(@p.syllables("extraordinary")).to eq([6, 5])
        end
      end

      context "with identical syllable counts" do
        it "returns an array with multiple identical syllable counts" do
          expect(@p.syllables("a")).to eq([1, 1])
        end
      end
    end

    context "words with only one pronunciation" do
      it "returns an array with one syllable count" do
        expect(@p.syllables("ruby")).to eq([2])
      end
    end
  end
end
