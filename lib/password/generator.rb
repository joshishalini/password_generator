module Password
  # This class is responsible to Generate Password
  class Generator
    SPECIAL_CHARS = %w[@ % ! ? * ^ &]
    NUMBER_CHARS = ('0'..'9').to_a
    LOWER_CHARS = ('a'..'z').to_a
    UPPER_CHARS = ('A'..'Z').to_a

    attr_reader :length, :uppercase, :lowercase, :number, :special, :error

    def initialize(length:, uppercase: true, lowercase: true, number: 2, special: 1)
		  @length = length
		  @uppercase = uppercase
		  @lowercase = lowercase
		  @number = number
		  @special = special
      @error = nil

		  validate_options
		end

    # Generate Password
    def generate
      return error if error

      password = []
      password += special_chars
      password += number_chars
      password += required_letters

      remaining = length - password.size

      password += Array.new(remaining) { available_letters.sample } unless remaining < 0

      password.shuffle.join
    end

    private

    # Validate arguments to check invalid options
    def validate_options
      unless length.is_a?(Integer) && length.positive?
        @error = "Length must be a positive integer."
        return
      end

      unless number.is_a?(Integer) && number >= 0
        @error = "Number must be a non-negative integer."
        return
      end

      unless special.is_a?(Integer) && special >= 0
        @error = "Special must be a non-negative integer."
        return
      end

      unless uppercase || lowercase
        @error = "At least one of uppercase or lowercase must be true."
        return
      end

      required_letters_count = (uppercase ? 1 : 0) + (lowercase ? 1 : 0)
      total_required = number + special + required_letters_count

      if total_required > length
        @error = "Password too short: length=#{length}, but requires at least #{total_required} characters."
      end
    end

    # Randmonly pick one speical char from SPECIAL_CHARS
    def special_chars
      Array.new(special) { SPECIAL_CHARS.sample }
    end

    # Randmonly pick one number from NUMBER_CHARS
    def number_chars
      Array.new(number) { NUMBER_CHARS.sample }
    end

    # Randmonly pick letters from UPPER_CHARS and LOWER_CHARS
    def required_letters
      letters = []
      letters << UPPER_CHARS.sample if uppercase
      letters << LOWER_CHARS.sample if lowercase
      letters
    end

    # Return available letters
    def available_letters
      chars = []
      chars += UPPER_CHARS if uppercase
      chars += LOWER_CHARS if lowercase
      chars
    end
  end
end

puts Password::Generator.new(length: 8, uppercase: true, lowercase: true, number: -1, special: 0).generate
