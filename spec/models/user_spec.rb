require 'rails_helper'

RSpec.describe User do
  describe 'enum' do
    context 'when calling user roles' do
      it 'returns a hash' do
        expected_hash = { "author"=>0, "guest"=>1 }
        expect(User.roles).to eq expected_hash
      end
    end
  end
end
