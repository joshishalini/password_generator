# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/password/generator'

RSpec.describe Password::Generator do
  subject(:generator) { described_class.new(**params) }

  describe '#generate' do
    context 'with valid inputs' do
      let(:params) { { length: 12, uppercase: true, lowercase: true, number: 3, special: 2 } }

      it 'returns success with a password of the expected length' do
        result = generator.generate
        expect(result[:success]).to eq(true)
        expect(result[:password].length).to eq(12)
      end

      it 'includes the required number of digits and special characters' do
        password = generator.generate[:password]
        digit_count = password.count(Password::Generator::NUMBER_CHARS.join)
        special_count = password.count(Password::Generator::SPECIAL_CHARS.join)

        expect(digit_count).to be >= 3
        expect(special_count).to be >= 2
      end
    end

    context 'when total requirements exceed length' do
      let(:params) { { length: 4, uppercase: true, lowercase: true, number: 2, special: 2 } }

      it 'returns an error with success false' do
        result = generator.generate
        expect(result[:success]).to eq(false)
        expect(result[:error].join).to include('Password too short')
      end
    end

    context 'with invalid parameter types' do
      let(:params) { { length: 'eight', uppercase: 'yes', lowercase: nil, number: 'two', special: -1 } }

      it 'returns an error due to validation failure' do
        result = described_class.new(**params).generate
        expect(result[:success]).to eq(false)

        expect(result[:error]).to include(
          'Lowercase must be provided.',
          'Length must be an integer.',
          'Number must be a non-negative integer.',
          'Special must be a non-negative integer.',
          'Uppercase must be a boolean value.',
          'Lowercase must be a boolean value.'
        )
      end
    end

    context 'when only lowercase is true' do
      let(:params) { { length: 10, uppercase: false, lowercase: true, number: 2, special: 1 } }

      it 'returns a valid password with only lowercase letters' do
        password = generator.generate[:password]
        expect(password).to match(/[a-z]/)
        expect(password).not_to match(/[A-Z]/)
      end
    end
  end
end
