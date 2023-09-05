# frozen_string_literal: true

require_relative '../api_caller'
require_relative '../errors/application_error'

RSpec.describe ApiCaller do
  describe '.call' do
    subject(:caller) { described_class.new(args) }
    let(:args) do
      {
        'type' => 'recreational',
        'minprice' => '0'
      }
    end

    context 'when query string is valid' do
      it 'fetches data' do
        caller.call

        expect(caller.activity).not_to be_nil
      end

      it 'does not raise an error' do
        expect { caller.call }.not_to raise_error
      end
    end

    context 'when query string is empty' do
      let(:args) { {} }

      it 'fetches data' do
        caller.call

        expect(caller.activity).not_to be_nil
      end

      it 'does not raise an error' do
        expect { caller.call }.not_to raise_error
      end
    end

    context 'when query string is invalid' do
      let(:args) { { 'type' => 'nonexistent-type-123' } }

      it 'raises ApplicationError' do
        expect { caller.call }.to raise_error(ApplicationError)
      end
    end
  end
end
