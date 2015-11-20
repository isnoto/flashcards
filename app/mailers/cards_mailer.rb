class CardsMailer < ApplicationMailer
  default from: Rails.application.secrets.smtp_email_address

  def pending_cards_notification(user)
    @name = user.name

    mail(to: user.email, subject: 'У вас появились карточки для повторения')
  end
end
