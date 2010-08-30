#
# Comparison module taken from:
# http://gist.github.com/raw/474363/c5382272965f4653b7f9b9f9a8ec8968818aa141/comparison.rb
#
class Comparison
  @@window = 64
  @@prelude = 12

  def self.window
    @@window
  end

  def self.window=(val)
    @@window = val
  end

  def self.prelude
    @@prelude
  end

  def self.prelude=(val)
    @@prelude = val
  end

  def initialize(expected, actual)
    @expected = expected
    @actual = actual
  end

  def same?
    @expected == @actual
  end

  def different_at
    if (@expected.nil? || @actual.nil?)
      0
    else
      i = 0
      while (i < @expected.size && i < @actual.size)
        if @expected[i] != @actual[i]
          break
        end
        i += 1
      end
      return i
    end
  end

  def message
    "Strings differ at position #{different_at}:\n" +
      "expected: #{chunk(@expected)}\n" +
      "  actual: #{chunk(@actual)}\n"
  end

  def chunk(s)
    prefix, middle, suffix = "...", "", "..."

    start = different_at - @@prelude
    if start < 0
      prefix = ""
      start = 0
    end

    stop = start + @@window
    if stop > s.size
      suffix = ""
      stop = s.size
    end

    [prefix, s[start...stop].inspect, suffix].join
  end
end
