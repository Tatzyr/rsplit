# -*- frozen_string_literal: true -*-

require "rsplit/version"

module RSplit
  def rsplit(str, sep = nil, limit = 0)
    valid_encoding?(str)
    sep = $; if sep.nil?
    case sep
    when NilClass
      nil # do nothing
    when String
      valid_encoding?(sep)
      sep = sep.reverse
    else
      raise TypeError, "wrong argument type #{sep.class} (expected String)"
    end

    if block_given?
      str.reverse.split(sep, limit).reverse_each do |elem|
        yield elem.reverse
      end
      str
    else
      str.reverse.split(sep, limit).map(&:reverse).reverse
    end
  end

  module_function :rsplit

  # Avoid Bug #11387
  # https://bugs.ruby-lang.org/issues/11387
  def self.valid_encoding?(string)
    raise ArgumentError, "invalid byte sequence in #{string.encoding.name}" unless string.valid_encoding?
  end
end

class String
  # :call-seq:
  #   rsplit(sep = $;, limit = 0) -> array
  #   rsplit(sep = $;, limit = 0) {|elem| block } -> str

  #
  # Divides string into substrings based on a delimiter (starting from right), returning an array of these substrings.
  #
  def rsplit(*args, &proc)
    RSplit.rsplit(self, *args, &proc)
  end
end
