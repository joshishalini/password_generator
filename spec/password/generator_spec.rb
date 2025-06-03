require 'rspec'
require_relative '../../lib/password/generator'

RSpec.describe Password::Generator do
  context 'valid password generation' do
    it 'generates password with correct length' do
      generator = described_class.new(length: 12, number: 2, special: 2)
      password = generator.generate
      expect(password.length).to eq(12)
    end

    it 'generates password with at least one lowercase char' do
      generator = described_class.new(length: 10, uppercase: false, lowercase: true, number: 2, special: 1)
      password = generator.generate
      expect(password).to match(/[a-z]/)
    end

    it 'generates password with at least one uppercase char' do
      generator = described_class.new(length: 6, uppercase: true, lowercase: false, number: 3, special: 1)
      password = generator.generate
      expect(password).to match(/[A-Z]/)
    end

    it 'generates password with exact number of digits' do
      generator = described_class.new(length: 6, uppercase: false, lowercase: true, number: 3, special: 1)
      password = generator.generate
      expect(password.scan(/\d/).count).to eq(3)
    end

    it 'generates password with exact number of special characters' do
      generator = described_class.new(length: 10, number: 2, special: 2)
      password = generator.generate
      expect(password.count(Password::Generator::SPECIAL_CHARS.join)).to eq(2)
    end
  end

  context 'error handling' do
    it 'returns error for non-positive length' do
      generator = described_class.new(length: 0, number: 1, special: 1)
      expect(generator.generate).to match(/Length must be a positive integer./i)
    end

    it 'returns error for negative number' do
      generator = described_class.new(length: 8, number: -1, special: 1)
      expect(generator.generate).to match(/number must be a non-negative integer/i)
    end

    it 'returns error for negative special' do
      generator = described_class.new(length: 8, number: 1, special: -1)
      expect(generator.generate).to match(/special must be/i)
    end

    it 'returns error when both uppercase and lowercase are false' do
      generator = described_class.new(length: 8, uppercase: false, lowercase: false, number: 1, special: 1)
      expect(generator.generate).to match(/at least one of uppercase or lowercase/i)
    end

    it 'returns error when total required characters exceed length' do
      generator = described_class.new(length: 3, number: 2, special: 2, uppercase: true, lowercase: false)
      expect(generator.generate).to match(/too short/i)
    end
  end
end
