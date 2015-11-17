class CardsMailer < ApplicationMailer
  default from: 'flashcards.se@gmail.com',
          template_path: 'mailers/cards'

  def pending_cards_notification(user)
    @name = user.name
    email = user.email
    mail(to: "#{email}", subject: 'У вас появились карточки для повторения')
  end
end
