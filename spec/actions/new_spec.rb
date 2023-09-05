# frozen_string_literal: true

require_relative '../../actions/new'
require_relative '../../errors/application_error'

RSpec.describe New do
  describe '.call' do
    subject(:result) { described_class.call(args) }
    let(:args) do
      {
        'key' => '123456'
      }
    end

    context 'when params are invalid' do
      let(:args) { { abra: 'cadabra' } }

      it 'raises ApplicationError' do
        expect { result }.to raise_error(ApplicationError)
      end
    end

    context 'when the activity already exists' do
      before do
        create(:activity, key: '123456')
      end

      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end

      it 'prints out the activity and relevant message' do
        output_string = ''
        expect { result }.to output(output_string).to_stdout
      end
    end

    context 'when the activity is new' do
      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end

      it 'prints out the activity and relevant message' do
        output_string = ''
        expect { result }.to output(output_string).to_stdout
      end
    end
  end
end
