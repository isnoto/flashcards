desc 'notify users for review pending cards_mailer'
task notify_pending_cards: :environment do
  User.notify_user_for_review_pending_cards
end