require 'rails_helper'

describe User do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user_id: user.id) }
  let!(:card) { create(:card, deck_id: deck.id) }

  context '.notify_pending_cards' do

    it 'sends an email when user has cards for review' do
      expect { User.notify_pending_cards }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end