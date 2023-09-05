# frozen_string_literal: true

require_relative '../../actions/new'
require_relative '../../errors/application_error'

RSpec.describe New do
  describe '.call' do
    subject(:result) { described_class.call(args) }
    let(:args) do
      {
        type: 'recreational'
      }
    end

    context 'when params are invalid' do
      let(:args) { { abra: 'cadabra' } }

      it 'raises ApplicationError' do
        expect { result }.to raise_error(ApplicationError)
      end
    end

    context 'when the activity already exists' do
      let!(:activity) { create(:activity) }

      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end

      it 'prints out the activity and relevant message' do
        output_string = "activity: #{activity[:key]}\n" \
                        "accessibility: #{acitivity[:accessibility]}\n" \
                        "type: #{activity[:type]}\n" \
                        "participants: #{activity[:participants]}\n" \
                        "price: #{activity[:price]}\n" \
                        "\nActivity already saved!\n"

        expect { result }.to output(output_string).to_stdout
      end
    end

    context 'when the activity is new' do
      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end

      it 'prints out the activity and relevant message' do
        output_string = "activity: #{args[:key]}" \
                        "accessibility: #{args[:accessibility]}" \
                        "type: #{args[:type]}" \
                        "participants: #{args[:participants]}" \
                        "priceasdfasdf: #{args[:price]}" \
                        "\nActivity already saved!\n"

        expect { result }.to output(output_string).to_stdout
      end
    end
  end
end
