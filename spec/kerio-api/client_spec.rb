require 'spec_helper'
require 'kerio-api/client'
require 'uri'

describe Kerio::Api::Client do

	let(:url){double(URI)}
	let(:session) do
		s = double(Kerio::Api::Session)
		allow(s).to receive(:login)
		s
	end

	describe '#initialize' do

		context 'defaults' do
			it 'creates session object' do

				expect(Kerio::Api::Session).to receive(:new).with(url, true, false).and_return(session)

				described_class.new(url: url)
			end
		end

		context 'insecure and debug' do
			it 'creates session object' do

				expect(Kerio::Api::Session).to receive(:new).with(url, false, true).and_return(session)

				described_class.new(url: url, insecure: true, debug: true)
			end
		end
	end

	describe '#method_missing' do
		let(:client){described_class.new(url: url)}
		let(:urva){double(Kerio::Api::Method::Generic)}

		before do
			allow(Kerio::Api::Session).to receive(:new).and_return(session)
		end

		it 'Returns method' do
			expect(Kerio::Api::Method::Generic).to receive(:new).with(names: [:Urva], session: session, args: [], block: nil).and_return(urva)
			expect(client.Urva).to eq urva
		end
	end
end
