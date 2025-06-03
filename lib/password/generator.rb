module Password
  class Generator
    SPECIAL_CHARS = %w[@ % ! ? * ^ &]
    NUMBER_CHARS = ('0'..'9').to_a
    LOWER_CHARS = ('a'..'z').to_a
    UPPER_CHARS = ('A'..'Z').to_a

    attr_reader :length, :uppercase, :lowercase, :number, :special

    def initialize(length:, uppercase: true, lowercase: true, number: 2, special: 1)
		  @length = length
		  @uppercase = uppercase
		  @lowercase = lowercase
		  @number = number
		  @special = special
		  validate_options
		end

    def generate
      password = []
      password += special_chars
      password += number_chars
      password += required_letters

      remaining = length - password.size
      password += Array.new(remaining) { available_letters.sample }

      password.shuffle.join
    end

    private

    def validate_options
      raise ArgumentError, 'Length must be positive' unless length.positive?
      raise ArgumentError, 'At least one of uppercase or lowercase must be true' unless uppercase || lowercase
      raise ArgumentError, 'Sum of number and special characters exceeds length' if (number + special) > length
    end

    def special_chars
      Array.new(special) { SPECIAL_CHARS.sample }
    end

    def number_chars
      Array.new(number) { NUMBER_CHARS.sample }
    end

    def required_letters
      letters = []
      letters << UPPER_CHARS.sample if uppercase
      letters << LOWER_CHARS.sample if lowercase
      letters
    end

    def available_letters
      chars = []
      chars += UPPER_CHARS if uppercase
      chars += LOWER_CHARS if lowercase
      chars
    end
  end
end

puts Password::Generator.new(length: 8, uppercase: true, lowercase: true, number: 2, special: 1).generate
