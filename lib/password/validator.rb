# frozen_string_literal: true

module Password
  # Validates input options for password generation.
  class Validator
    attr_reader :length, :uppercase, :lowercase, :number, :special
    attr_accessor :errors

    # Maximum allowed length for a generated password
    MAX_LENGTH = 1024

    # Initializes the validator with user-specified parameters
    # @param length [Integer] total password length
    # @param uppercase [Boolean] include uppercase letters
    # @param lowercase [Boolean] include lowercase letters
    # @param number [Integer] minimum number of digits
    # @param special [Integer] minimum number of special characters
    def initialize(length:, uppercase:, lowercase:, number:, special:)
      @length    = length
      @uppercase = uppercase
      @lowercase = lowercase
      @number    = number
      @special   = special
      @errors = []
    end

    # Runs all validation checks and populates errors array
    # @return [Boolean] true if all validations pass, false otherwise
    def valid?
      check_presence	# Ensure all fields are present
      check_length                        # Validate password length constraints
      check_number                        # Validate number is non-negative integer
      check_special_char                  # Validate special is non-negative integer
      check_letter_flags                  # Validate uppercase/lowercase flags
      check_total_required_fits_length    # Validate requirements don't exceed total length

      errors.empty?
    end

    private

    # Check that no required parameters are missing (nil)
    def check_presence
      %i[length uppercase lowercase number special].each do |param|
        errors << "#{param.capitalize} must be provided." if instance_variable_get("@#{param}").nil?
      end
    end

    # Check if length is a valid integer, within allowed range
    def check_length
      if length.is_a?(Integer)
        errors << 'Length must be a positive integer.' unless length.positive?
        errors << "Length cannot exceed #{MAX_LENGTH} characters." if length > MAX_LENGTH
      else
        errors << 'Length must be an integer.'
      end
    end

    # Check that number of digits is a non-negative integer
    def check_number
      return if number.is_a?(Integer) && number >= 0

      errors << 'Number must be a non-negative integer.'
    end

    # Check that number of special characters is a non-negative integer
    def check_special_char
      return if special.is_a?(Integer) && special >= 0

      errors << 'Special must be a non-negative integer.'
    end

    # Validate boolean nature of letter flags, and that at least one is true
    def check_letter_flags
      errors << 'Uppercase must be a boolean value.' unless [true, false].include?(uppercase)

      errors << 'Lowercase must be a boolean value.' unless [true, false].include?(lowercase)

      return unless [true,
                     false].include?(uppercase) && [true, false].include?(lowercase) && !uppercase && !lowercase

      errors << 'At least one of uppercase or lowercase must be true.'
    end

    # Ensure the sum of all required characters does not exceed the total password length
    def check_total_required_fits_length
      return unless length.is_a?(Integer) && number.is_a?(Integer) && special.is_a?(Integer)

      required_letters = (uppercase ? 1 : 0) + (lowercase ? 1 : 0)
      total_required = number + special + required_letters

      return unless total_required > length

      errors << "Password too short: length=#{length}, but requires at least #{total_required} characters."
    end
  end
end
