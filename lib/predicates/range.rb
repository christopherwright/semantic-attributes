# Lets you declare a range for a numeric value.
# options:
# * :above
# * :below
# * :range
class Predicates::Range < Predicates::Number
  # when the range has just a min
  attr_accessor :above

  # when the range has just a max
  attr_accessor :below

  # when the range has both a max and a min
  attr_accessor :range

  # meant to be used with :above and :below, when you want the endpoint to be inclusive.
  # with the :range option you can just specify inclusion using the standard Ruby range syntax.
  attr_accessor :inclusive

  def error_message
    @error_message || "%s must be #{range_description}."
  end

  def validate(value, record)
    if super
      if self.range
        self.range.include? value
      elsif self.above
        operator = self.inclusive ? :>= : :>
        value.send operator, self.above
      elsif self.below
        operator = self.inclusive ? :<= : :<
        value.send operator, self.below
      else
        true
      end
    end
  end

  protected

  def range_description
    return "a number from #{self.range.first} #{self.range.exclude_end? ? 'to' : 'through'} #{self.range.last}" if self.range
    if inclusive
      return "at least #{self.above}" if self.above
      return "no more than #{self.below}" if self.below
    else
      return "more than #{self.above}" if self.above
      return "less than #{self.below}" if self.below
    end
    raise 'undetermined range'
  end
end