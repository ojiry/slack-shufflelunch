require 'rails_helper'

RSpec.describe LunchBuilder, type: :model do
  describe '#build!' do
    # let(:params) {
    #   {
    #     team_id: 'T001',
    #     team_domain: 'example',
    #     channel_id: 'C001',
    #     channel_name: 'test',
    #     user_id: 'U001',
    #     user_name: 'otako'
    #   }
    # }
    # let(:lunch_builder) { LunchBuilder.new(params) }

    # it { expect(lunch_builder.build!).to be_a(Lunch) }

    # it { expect { lunch_builder.build! }.to change { User.count }.by(1).and change { Lunch.count }.by(1) }

    # context 'when params is invalid' do
    #   let(:params) {
    #     {
    #       team_id: 'T001',
    #       team_domain: 'example',
    #       channel_id: 'C001',
    #       channel_name: 'test'
    #     }
    #   }

    #   it { expect { lunch_builder.build! }.to raise_error(ActiveRecord::RecordInvalid) }
    # end
  end
end
