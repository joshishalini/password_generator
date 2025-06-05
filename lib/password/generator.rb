# frozen_string_literal: true

require_relative './validator'

module Password
  # This class is responsible for generating secure passwords
  class Generator
    SPECIAL_CHARS = %w[@ % ! ? * ^ &].freeze
    NUMBER_CHARS = ('0'..'9').to_a
    LOWER_CHARS = ('a'..'z').to_a
    UPPER_CHARS = ('A'..'Z').to_a

    attr_reader :length, :uppercase, :lowercase, :number, :special, :errors

    # Initialize the generator with configuration options
    def initialize(length:, uppercase: true, lowercase: true, number: 2, special: 1)
      @length = length
      @uppercase = uppercase
      @lowercase = lowercase
      @number = number
      @special = special
      @errors = []

      validate_options
    end

    # Generates a password
    # Returns a hash with success status and either password or error message
    # @return [Hash]
    def generate
      return { success: false, error: errors } unless errors.empty?

      password = build_password

      { success: true, password: password }
    end

    private

    # Validates the input parameters using the Validator class
    def validate_options
      validator = Password::Validator.new(
        length: length,
        uppercase: uppercase,
        lowercase: lowercase,
        number: number,
        special: special
      )

      unless validator.valid?
        @errors = validator.errors
      end
    end

    # Build the password by assembling required components
    # @return [String]
    def build_password
      password = []
      password += pick_random(SPECIAL_CHARS, special)
      password += pick_random(NUMBER_CHARS, number)
      password += required_letters

      remaining = length - password.size

      # Fill remaining characters with random letters from available letters
      password += pick_random(available_letters, remaining) unless remaining.negative?

      password.shuffle.join # Shuffle to randomize order
    end

    # Returns a random selection of characters from a source array
    def pick_random(source, count)
      return [] if count <= 0

      Array.new(count) { source.sample }
    end

    # Randomly picks one letter from each selected case (upper/lower)
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

# Example usage
puts Password::Generator.new(length: 8, uppercase: false, lowercase: true, number: 1, special: 1).generate
