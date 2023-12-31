# frozen_string_literal: true

require_relative '../../lib/actions/list'
require_relative '../../lib/errors/application_error'

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
      let!(:activity1) { create(:activity) }
      let!(:activity2) { create(:activity) }

      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end

      it 'prints out the relevant message' do
        output_message = "Activities:\n\n" \
                         "activity: #{activity2[:activity]}\n" \
                         "type: #{activity2[:type]}\n" \
                         "accessibility: #{activity2[:accessibility]}\n" \
                         "participants: #{activity2[:participants]}\n" \
                         "price: #{activity2[:price]}\n" \
                         "key: #{activity2[:key]}\n" \
                         "link: #{activity2[:link]}\n\n" \
                         "activity: #{activity1[:activity]}\n" \
                         "type: #{activity1[:type]}\n" \
                         "accessibility: #{activity1[:accessibility]}\n" \
                         "participants: #{activity1[:participants]}\n" \
                         "price: #{activity1[:price]}\n" \
                         "key: #{activity1[:key]}\n" \
                         "link: #{activity1[:link]}\n"
        expect { result }.to output(output_message).to_stdout
      end
    end
  end
end
