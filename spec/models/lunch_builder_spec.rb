require 'rails_helper'

RSpec.describe LunchBuilder, type: :model do
  describe '#build!' do
    let(:slack_parameter) {
      Slack::Parameter.new(
        team_id: 'T001',
        team_domain: 'example',
        channel_id: 'C001',
        channel_name: 'test',
        user_id: 'U001',
        user_name: 'otako',
        response_url: 'http://dummy.url'
      )
    }
    let(:lunch_builder) { LunchBuilder.new(slack_parameter) }

    it { expect(lunch_builder.build!).to be_a(Lunch) }

    it { expect { lunch_builder.build! }.to change { User.count }.by(1).and change { Lunch.count }.by(1) }

    context 'when params is invalid' do
      let(:slack_parameter) {
        Slack::Parameter.new(
          team_id: 'T001',
          team_domain: 'example',
          channel_id: 'C001',
          channel_name: 'test',
          user_id: 'U001',
          user_name: 'otako'
        )
      }

      it { expect { lunch_builder.build! }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end
end
