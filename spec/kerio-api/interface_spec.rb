require 'spec_helper'
require 'kerio-api/interface'
require 'uri'

describe Kerio::Api::Interface do

	let(:session){Kerio::Api::Session.new(double(URI))}
	let(:interface){described_class.new('iface', session)}

	describe '#method_missing' do

		it 'Calls request' do

			params = double(Hash)

			expect(session).to receive(:request).with('iface.meth', params)
			interface.meth(params)
		end
	end
end
