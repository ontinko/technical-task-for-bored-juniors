# frozen_string_literal: true

require_relative '../cli_handler'
require_relative '../errors/application_error'

RSpec.describe CliHandler do
  describe '.call' do
    subject(:handler) { described_class.new(argv) }
    let(:argv) { [] }

    context 'when no arguments are provided' do
      it 'raises ApplicationError' do
        expect { handler.call }.to raise_error(ApplicationError)
      end
    end

    context 'when list command has additional parameters' do
      let(:argv) { %w[list all the records] }

      it 'raises ApplicationError' do
        expect { handler.call }.to raise_error(ApplicationError)
      end
    end

    context 'when new command has unpermitted parameters' do
      let(:argv) { %w[new --language ruby] }
      it 'raises ApplicationError' do
        expect { handler.call }.to raise_error(ApplicationError)
      end
    end

    context 'when list command is valid' do
      let(:argv) { %w[list] }

      it 'does not raise an error' do
        expect { handler.call }.not_to raise_error
      end

      it 'prints out database contents' do
        # works
      end
    end

    context 'when new command has no parameters' do
      let(:argv) { %w[new] }

      it 'does not raise an error' do
        expect { handler.call }.not_to raise_error
      end
    end

    context 'when new command has valid parameters' do
      let(:argv) { %w[new --type education] }

      it 'does not raise an error' do
        expect { handler.call }.not_to raise_error
      end
    end
  end
end
