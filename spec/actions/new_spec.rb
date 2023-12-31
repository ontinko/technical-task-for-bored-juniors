# frozen_string_literal: true

require_relative '../../lib/actions/new'
require_relative '../../lib/errors/application_error'
require 'json'

RSpec.describe New do
  describe '.call' do
    subject(:result) { described_class.call(args) }

    let(:args) { { type: 'recreational' } }
    let(:response_body) { '' }
    let(:response_status) { 200 }

    before do
      stub_request(:get, BASE_URI)
        .with(query: hash_including(args))
        .to_return(body: response_body, status: response_status)
    end

    context 'when params are invalid' do
      let(:args) { { abra: 'cadabra' } }

      it 'raises ApplicationError' do
        expect { result }.to raise_error(ApplicationError)
      end
    end

    context 'when the activity already exists' do
      let(:activity_attrs) do
        {
          key: '123456',
          activity: 'sleeping',
          type: 'relaxation',
          accessibility: 1.0,
          participants: 1,
          price: 0.0
        }
      end
      let!(:activity) { create(:activity, **activity_attrs) }
      let(:response_body) { activity_attrs.to_json }

      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end

      it 'prints out the activity and relevant message' do
        output_string = "activity: #{activity[:activity]}\n" \
                        "type: #{activity[:type]}\n" \
                        "accessibility: #{activity[:accessibility]}\n" \
                        "participants: #{activity[:participants]}\n" \
                        "price: #{activity[:price]}\n" \
                        "key: #{activity[:key]}\n" \
                        "link: #{activity[:link]}\n" \
                        "\nActivity already saved!\n"

        expect { result }.to output(output_string).to_stdout
      end
    end

    context 'when the activity is new' do
      let(:new_activity) do
        {
          'activity' => 'sleeping',
          'accessibility' => '1.0',
          'type' => 'relaxation',
          'participants' => '2',
          'price' => '0.0'
        }
      end
      let(:response_body) { new_activity.to_json }

      it 'does not raise an error' do
        expect { result }.not_to raise_error
      end

      it 'prints out the activity and relevant message' do
        output_string = "activity: #{new_activity['activity']}\n" \
                        "type: #{new_activity['type']}\n" \
                        "accessibility: #{new_activity['accessibility']}\n" \
                        "participants: #{new_activity['participants']}\n" \
                        "price: #{new_activity['price']}\n" \
                        "key: #{new_activity['key']}\n" \
                        "link: #{new_activity['link']}\n" \
                        "\nNew activity added!\n"

        expect { result }.to output(output_string).to_stdout
      end
    end
  end
end
