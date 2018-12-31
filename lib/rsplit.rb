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

    str.reverse.split(sep, limit).map(&:reverse).reverse
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
  #   rsplit(sep = $;, limit = 0)
  #
  # Divides string into substrings based on a delimiter (starting from right), returning an array of these substrings.
  #
  def rsplit(*args)
    RSplit.rsplit(self, *args)
  end
end
