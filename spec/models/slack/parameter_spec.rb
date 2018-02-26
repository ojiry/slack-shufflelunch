require 'rails_helper'

RSpec.describe Slack::Parameter, type: :model do
  let(:parameter) { Slack::Parameter.new(params) }

  shared_context "slash commands params" do
    let(:params) {
      {
        commands: '/shufflelunch'
      }
    }
  end

  shared_context "interactive messages params" do
    let(:params) {
      {
        payload: {
          actions: [
            {
              name: "join",
              type: "button",
              value: "join"
            }
          ]
        }.to_json
      }
    }
  end

  shared_context "event subscriptions params" do
    let(:params) {
      {
        event: {
          text: "text"
        }
      }
    }
  end

  describe "#actions" do
    subject { parameter.actions }

    context "when params type is slash commands" do
      include_context "slash commands params"

      it { is_expected.to eq [] }
    end

    context "when params type is interactive messages" do
      include_context "interactive messages params"

      it { is_expected.to eq [{ "name" => "join", "type" => "button", "value" => "join" }] }
    end

    context "when params type is event subscriptions" do
      include_context "event subscriptions params"

      it { is_expected.to eq [] }
    end
  end
end
