# frozen_string_literal: true

require_relative '../api_caller'
require_relative '../errors/application_error'
require 'json'

RSpec.describe ApiCaller do
  describe '.call' do
    subject(:caller) { described_class.new(args) }
    let(:args) { {} }
    let(:response_body) { { activity: 'hehe', key: 'hoho' }.to_json }
    let(:response_status) { 200 }

    before do
      stub_request(:get, BASE_URI)
        .with(query: hash_including(args))
        .to_return(body: response_body, status: response_status)
    end

    context 'when query string is valid' do
      let(:args) do
        {
          'type' => 'recreational',
          'minprice' => '0'
        }
      end

      it 'fetches data' do
        caller.call

        expect(caller.activity).not_to be_nil
      end

      it 'does not raise an error' do
        expect { caller.call }.not_to raise_error
      end
    end

    context 'when query string is empty' do
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
      let(:response_body) { { 'error' => '' }.to_json }

      it 'raises ApplicationError' do
        expect { caller.call }.to raise_error(ApplicationError)
      end
    end
  end
end
