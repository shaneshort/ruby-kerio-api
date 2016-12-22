require 'spec_helper'
require 'kerio-api/error'

describe Kerio::Api::Error do
	context 'json-rpc' do

		let(:http_resp) do
			resp = double(HTTParty::Response)
			allow(resp).to receive(:code).and_return('999')
			allow(resp).to receive(:[]).with('jsonrpc').and_return(true)
			allow(resp).to receive(:[]).with('error').and_return({"message" => 'Error!!!'})
			allow(resp).to receive(:headers).and_return({h1: 'h1', h2: 'h2'})

			resp
		end

		let(:error){described_class.new(http_resp)}

		describe '#headers' do
			it 'returns headers' do
				expect(error.headers).to include(h1: 'h1', h2: 'h2')
			end
		end

		describe '#resp' do
			it 'returns resp' do
				expect(error.resp).to be http_resp
			end
		end

		describe '#to_s' do
			subject{error.to_s}

			it 'Returns error message' do
				expect(subject).to eq "Http code: 999, json-rpc message: Error!!!"
			end
		end
	end

	context 'http' do

		let(:http_resp) do
			resp = double(HTTParty::Response)
			allow(resp).to receive(:code).and_return('999')
			allow(resp).to receive(:[]).with('jsonrpc').and_return(nil)
			allow(resp).to receive(:headers).and_return({h1: 'h1', h2: 'h2'})

			resp
		end

		let(:error){described_class.new(http_resp)}

		describe '#headers' do
			it 'returns headers' do
				expect(error.headers).to include(h1: 'h1', h2: 'h2')
			end
		end

		describe '#resp' do
			it 'returns resp' do
				expect(error.resp).to be http_resp
			end
		end

		describe '#to_s' do
			subject{error.to_s}

			it 'Returns error message' do
				expect(subject).to eq "Http code: 999"
			end
		end
	end
end
