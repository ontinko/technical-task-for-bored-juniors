# frozen_string_literal: true

require_relative '../../actions/list'
require_relative '../../errors/application_error'

RSpec.describe List do
  describe '.call' do
    subject(:result) { described_class.call(args) }
    let(:args) { {} }

    context 'when params are invalid' do
      let(:args) { { unneeded: :parameter } }

      it 'raises ApplicationError' do
        expect { result }.to raise_error(ApplicationError)
      end
    end

    context 'when the database is empty' do
      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end

      it 'prints out the relevant message' do
        expect { result }.to output("No activities saved!\n").to_stdout
      end
    end

    context 'when the database is populated' do
      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end
    end
  end
end
