require 'spec_helper'

RSpec.describe Bitgo::Session do
  let(:token) { double(:token) }
  let(:data) { get_fixture('session.json') }

  describe 'attributes' do
    subject { described_class.new(token, data) }

    specify(:client) { expect(subject.client).to eq data['client'] }
    specify(:user) { expect(subject.user).to eq data['user'] }
    specify(:expires) { expect(subject.expires).to eq data['expires'] }
    specify(:origin) { expect(subject.origin).to eq data['origin'] }
  end
end
