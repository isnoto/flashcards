desc 'notify users for review pending cards'
task notify_users: :environment do
  Card.notify_user_for_review_pending_cards
end