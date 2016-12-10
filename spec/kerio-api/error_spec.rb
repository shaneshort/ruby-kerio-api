require 'spec_helper'
require 'kerio-api/error'

describe Kerio::Api::Error do

	let(:error){described_class.new({"error" => {"message" => 'Error!!!'}}, {h1: 'h1', h2: 'h2'})}

	describe '#headers' do
		it 'returns headers' do
			expect(error.headers).to include(h1: 'h1', h2: 'h2')
		end
	end

	describe '#resp' do
		it 'returns resp' do
			expect(error.resp).to include("error")
		end
	end

	describe '#to_s' do
		subject{error.to_s}

		it 'Returns error message' do
			expect(subject).to eq "Error!!!"
		end
	end
end
