every 1.day, at: '00:00' do
  runner "User.notify_pending_cards"
end
