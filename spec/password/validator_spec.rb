require 'rspec'
require_relative '../../lib/password/validator'

RSpec.describe Password::Validator do
  subject(:validator) { described_class.new(**params) }

  describe '#valid?' do
    context 'with valid input' do
      let(:params) { { length: 10, uppercase: true, lowercase: true, number: 2, special: 1 } }

      it 'returns true and has no errors' do
        expect(validator.valid?).to eq(true)
        expect(validator.errors).to be_empty
      end
    end

    context 'with missing parameters' do
      let(:params) { { length: nil, uppercase: nil, lowercase: nil, number: nil, special: nil } }

      before { validator.valid? }

      it 'collects all missing field errors' do
        expect(validator.errors).to include(
          "Length must be provided.",
          "Uppercase must be provided.",
          "Lowercase must be provided.",
          "Number must be provided.",
          "Special must be provided."
        )
      end
    end

    context 'with invalid length' do
      let(:params) { { length: -10, uppercase: true, lowercase: true, number: 2, special: 1 } }

      it 'fails when length is not a positive integer' do
        expect(validator.valid?).to eq(false)
        expect(validator.errors).to include("Length must be a positive integer.")
      end
    end

    context 'with invalid number' do
      let(:params) { { length: 8, uppercase: true, lowercase: true, number: -2, special: 1 } }

      it 'fails when number is negative' do
        expect(validator.valid?).to eq(false)
        expect(validator.errors).to include("Number must be a non-negative integer.")
      end
    end

    context 'with invalid special' do
      let(:params) { { length: 8, uppercase: true, lowercase: true, number: 2, special: -1 } }

      it 'fails when special is negative' do
        expect(validator.valid?).to eq(false)
        expect(validator.errors).to include("Special must be a non-negative integer.")
      end
    end

    context 'with invalid uppercase and lowercase' do
      let(:params) { { length: 8, uppercase: 0, lowercase: nil, number: 2, special: 1 } }

      it 'fails when uppercase and lowercase are not booleans' do
        expect(validator.valid?).to eq(false)
        expect(validator.errors).to include(
          "Uppercase must be a boolean value.",
          "Lowercase must be a boolean value."
        )
      end
    end

    context 'when both uppercase and lowercase are false' do
      let(:params) { { length: 8, uppercase: false, lowercase: false, number: 2, special: 1 } }

      before { validator.valid? }

      it 'fails with message requiring at least one letter case' do
        expect(validator.errors).to include("At least one of uppercase or lowercase must be true.")
      end
    end

    context 'when total required characters exceed length' do
      let(:params) { { length: 3, uppercase: true, lowercase: true, number: 2, special: 1 } }

      before { validator.valid? }

      it 'fails with error indicating password too short' do
        expect(validator.errors).to include("Password too short: length=3, but requires at least 5 characters.")
      end
    end

    context 'when length is equal to total required characters' do
      let(:params) { { length: 5, uppercase: true, lowercase: true, number: 2, special: 1 } }

      it 'passes when total matches length exactly' do
        expect(validator.valid?).to eq(true)
        expect(validator.errors).to be_empty
      end
    end

    context 'when length exceeds maximum allowed' do
      let(:params) { { length: 2000, uppercase: true, lowercase: true, number: 2, special: 1 } }

      before { validator.valid? }

      it 'fails with max length exceeded error' do
        expect(validator.errors).to include("Length cannot exceed 1024 characters.")
      end
    end
  end
end
