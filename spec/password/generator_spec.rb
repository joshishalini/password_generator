require 'rspec'

require_relative '../../lib/password/generator'

RSpec.describe Password::Generator do
  context 'valid password generation' do
    it 'generate password with correct length' do
      generator = described_class.new(length: 12, number: 2, special: 2)
      password = generator.generate
      expect(password.length).to eq(12)
    end

    it 'generate password with minimum one lowercase char' do
      generator = described_class.new(length: 10, uppercase: false, lowercase: true, number: 2, special: 1)
      password = generator.generate
      expect(password).to match(/[a-z]/)
    end

    it 'generate password with minimum one uppercase char' do
      generator = described_class.new(length: 5, uppercase: true, lowercase: false, number: 3, special: 1)
      password = generator.generate
      expect(password).to match(/[A-Z]/)
    end

    it 'generate password with expect 3 number' do
      generator = described_class.new(length: 5, uppercase: false, lowercase: true, number: 3, special: 1)
      password = generator.generate
      digit_count = password.scan(/\d/).count
      expect(digit_count).to eq(3)
    end

    it 'includes the correct number of special characters' do
      generator = described_class.new(length: 10, number: 2, special: 2)
      password = generator.generate
      special_count = password.count(Password::Generator::SPECIAL_CHARS.join)
      expect(special_count).to eq(2)
    end
  end

  context 'error handling' do
    it 'raises error for non-positive length' do
      expect {
        described_class.new(length: 0, number: 1, special: 1)
      }.to raise_error(ArgumentError, /Length must be positive/)
    end

    it 'raises error when number + special exceeds length' do
      expect {
        described_class.new(length: 3, number: 3, special: 2)
      }.to raise_error(ArgumentError, /Sum of number and special/)
    end

    it 'raises error when both uppercase and lowercase are false' do
      expect {
        described_class.new(length: 8, uppercase: false, lowercase: false, number: 1, special: 1)
      }.to raise_error(ArgumentError, /At least one/)
    end
  end
end
