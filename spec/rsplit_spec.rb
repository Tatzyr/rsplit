# -*- frozen_string_literal: true -*-

require "spec_helper"

describe RSplit do
  it "has a version number" do
    expect(RSplit::VERSION).not_to be_nil
  end

  describe String do
    describe "#rsplit" do
      it "throws a TypeError if the separator is Regexp" do
        expect { "str".rsplit(/\w/) }.to raise_error(TypeError)
      end

      it "splits on multibyte characters" do
        expect("ありがりがとう".rsplit("が")).to eq(["あり", "り", "とう"])
      end

      it "throws a TypeError if limit can't be converted to an integer" do
        expect { "1.2.3.4".rsplit(".", "three") }.to raise_error(TypeError)
        expect { "1.2.3.4".rsplit(".", nil) }.to raise_error(TypeError)
      end

      it "returns an array of substrings based on splitting on the given string" do
        expect("mellow yellow".rsplit("ello")).to eq(["m", "w y", "w"])
      end

      it "suppresses trailing empty fields when limit isn't given or 0" do
        expect("1,2,,3,4,,".rsplit(",")).to eq(["1", "2", "", "3", "4", "", ""])
        expect("1,2,,3,4,,".rsplit(",", 0)).to eq(["1", "2", "", "3", "4", "", ""])
        expect("  a  b  c\nd  ".rsplit("  ")).to eq(["a", "b", "c\nd", ""])
        expect("hai".rsplit("hai")).to be_empty
        expect(",".rsplit(",")).to be_empty
        expect(",".rsplit(",", 0)).to be_empty
      end

      it "returns an array with one entry if limit is 1: the original string" do
        expect("hai".rsplit("hai", 1)).to eq(["hai"])
        expect("x.y.z".rsplit(".", 1)).to eq(["x.y.z"])
        expect("hello world ".rsplit(" ", 1)).to eq(["hello world "])
        expect(" hello world".rsplit(" ", 1)).to eq([" hello world"])
        expect("hi!".rsplit("", 1)).to eq(["hi!"])
      end

      it "returns at most limit fields when limit > 1" do
        expect("hai".rsplit("hai", 2)).to eq(["", ""])

        expect("1,2,,3,4,,".rsplit(",", 2)).to eq(["1,2,,3,4,", ""])
        expect("1,2,,3,4,,".rsplit(",", 3)).to eq(["1,2,,3,4", "", ""])
        expect("1,2,,3,4,,".rsplit(",", 4)).to eq(["1,2,,3", "4", "", ""])
        expect("1,2,,3,4,,".rsplit(",", 5)).to eq(["1,2,", "3", "4", "", ""])
        expect("1,2,,3,4,,".rsplit(",", 6)).to eq(["1,2", "", "3", "4", "", ""])

        expect(",,1,2,,3,4".rsplit(",", 2)).to eq([",,1,2,,3", "4"])
        expect(",,1,2,,3,4".rsplit(",", 3)).to eq([",,1,2,", "3", "4"])
        expect(",,1,2,,3,4".rsplit(",", 4)).to eq([",,1,2", "", "3", "4"])
        expect(",,1,2,,3,4".rsplit(",", 5)).to eq([",,1", "2", "", "3", "4"])
        expect(",,1,2,,3,4".rsplit(",", 6)).to eq([",", "1", "2", "", "3", "4"])

        expect("x".rsplit("x", 2)).to eq(["", ""])
        expect("xx".rsplit("x", 2)).to eq(["x", ""])
        expect("xx".rsplit("x", 3)).to eq(["", "", ""])
        expect("xxx".rsplit("x", 2)).to eq(["xx", ""])
        expect("xxx".rsplit("x", 3)).to eq(["x", "", ""])
        expect("xxx".rsplit("x", 4)).to eq(["", "", "", ""])
      end

      it "doesn't suppress or limit fields when limit is negative" do
        expect("1,2,,3,4,,".rsplit(",", -1)).to eq(["1", "2", "", "3", "4", "", ""])
        expect("1,2,,3,4,,".rsplit(",", -5)).to eq(["1", "2", "", "3", "4", "", ""])
        expect("  a  b  c\nd  ".rsplit("  ", -1)).to eq(["", "a", "b", "c\nd", ""])
        expect(",".rsplit(",", -1)).to eq(["", ""])
      end

      it "defaults to $; when string isn't given or nil" do
        old_fs = $;

        [",", ":", "", "XY", nil].each do |fs|
          $; = fs

          ["x,y,z,,,", "1:2:", "aXYbXYcXY", ""].each do |str|
            expected = str.rsplit(fs || " ")

            expect(str.rsplit(nil)).to eq(expected)
            expect(str.rsplit).to eq(expected)

            expect(str.rsplit(nil, -1)).to eq(str.rsplit(fs || " ", -1))
            expect(str.rsplit(nil, 0)).to eq(str.rsplit(fs || " ", 0))
            expect(str.rsplit(nil, 2)).to eq(str.rsplit(fs || " ", 2))
          end
        end
      ensure
        $; = old_fs
      end

      it "ignores leading and continuous whitespace when string is a single space" do
        expect("  now's  the time ".rsplit(" ")).to eq(["now's", "the", "time"])
        expect("  now's  the time ".rsplit(" ", -1)).to eq(["", "now's", "the", "time"])
        expect("  now's  the time ".rsplit(" ", 3)).to eq(["  now's", "the", "time"])

        expect("\t\n a\t\tb \n\r\r\nc\v\vd\v ".rsplit(" ")).to eq(["a", "b", "c", "d"])
        expect("a\x00a b".rsplit(" ")).to eq(["a\x00a", "b"])
      end

      it "splits between characters when its argument is an empty string" do
        expect("hi!".rsplit("")).to eq(["h", "i", "!"])
        expect("hi!".rsplit("", -1)).to eq(["", "h", "i", "!"])
        expect("hi!".rsplit("", 2)).to eq(["hi", "!"])
      end

      it "doesn't set $~" do
        $~ = nil
        "x.y.z".rsplit(".")
        expect($~).to be_nil
      end

      it "returns the original string if no matches are found" do
        expect("foo".rsplit("bar")).to eq(["foo"])
        expect("foo".rsplit("bar", -1)).to eq(["foo"])
        expect("foo".rsplit("bar", 0)).to eq(["foo"])
        expect("foo".rsplit("bar", 1)).to eq(["foo"])
        expect("foo".rsplit("bar", 2)).to eq(["foo"])
        expect("foo".rsplit("bar", 3)).to eq(["foo"])
      end

      it "returns subclass instances based on self" do
        ["", "x.y.z.", "  x  y  "].each do |str|
          ["", ".", " "].each do |pat|
            [-1, 0, 1, 2].each do |limit|
              MyString.new(str).rsplit(pat, limit).each do |x|
                expect(x).to be_an_instance_of(MyString)
              end

              str.rsplit(MyString.new(pat), limit).each do |x|
                expect(x).to be_an_instance_of(String)
              end
            end
          end
        end
      end

      it "taints the resulting strings if self is tainted" do
        ["", "x.y.z.", "  x  y  "].each do |str|
          ["", ".", " "].each do |pat|
            [-1, 0, 1, 2].each do |limit|
              str.dup.taint.rsplit(pat).each do |x|
                expect(x).to be_tainted
              end

              str.rsplit(pat.dup.taint).each do |x|
                expect(x).not_to be_tainted
              end
            end
          end
        end
      end

      it "doesn't taints the resulting strings if the pattern is tainted" do
        ["", "x:y:z:", "  x  y  "].each do |str|
          ["", ":", " "].each do |pat|
            [-1, 0, 1, 2].each do |limit|
              str.rsplit(pat.dup.taint, limit).each do |x|
                expect(x).not_to be_tainted
              end
            end
          end
        end
      end

      it "retains the encoding of the source string" do
        ary = "а б в".rsplit
        encodings = ary.map { |s| s.encoding }
        expect(encodings).to eq([Encoding::UTF_8, Encoding::UTF_8, Encoding::UTF_8])
      end

      it "splits a string on each character for a multibyte encoding and empty split" do
        expect("That's why eﬃciency could not be helped".rsplit("").size).to eq(39)
        expect("俺の想いよルイズへ届け！！ハルケギニアのルイズへ届け！".rsplit("").size).to eq(27)
      end

      context "avoid interpreter's bug" do
        it "throws an ArgumentError if the pattern is not a valid string" do
          str = "проверка"
          broken_str = +"проверка"
          broken_str.force_encoding("binary")
          broken_str.chop!
          broken_str.force_encoding("utf-8")
          broken_str.freeze
          expect { str.rsplit(broken_str) }.to raise_error(ArgumentError)
        end
      end

      context "Ruby 2.6+" do
        if Gem::Version.create(RUBY_VERSION) >= Gem::Version.create("2.6")
          it "yields each split substrings if a block is given" do
            a = []
            returned_object = "foo/bar/baz/foo/bar/baz".rsplit("/", 3) {|s| a << s.capitalize }
            expect(returned_object).to eq("foo/bar/baz/foo/bar/baz")
            expect(a).to eq(["Foo/bar/baz/foo", "Bar", "Baz"])
          end
        end
      end
    end
  end
end
