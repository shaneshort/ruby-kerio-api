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

		it 'creates session object' do

			expect(Kerio::Api::Session).to receive(:new).with(url).and_return(session)

			described_class.new(url: url)
		end
	end

	describe '#method_missing' do
		let(:client){described_class.new(url: url, user: 'username', password: 'pass')}
		let(:method){double(Kerio::Api::Method::Generic)}
		let(:urva){double(Kerio::Api::Method::Generic)}

		before do
			allow(Kerio::Api::Session).to receive(:new).and_return(session)
		end

		it 'Returns method' do
			expect(Kerio::Api::Method::Generic).to receive(:new).with(names: [], session: session).and_return(method)
			expect(method).to receive(:Urva).and_return(urva)
			expect(client.Urva).to eq urva
		end
	end
end
