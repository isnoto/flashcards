desc 'notify users for review pending cards'
task notify_pending_cards: :environment do
  User.notify_pending_cards
end
