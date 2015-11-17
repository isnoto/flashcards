every 1.day, at: '00:00' do
  runner "Cards.notify_user_for_review_pending_cards"
end