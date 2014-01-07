class SharePaymentMailer < ActionMailer::Base
  default from: 'service@andromoney.com'

  def share_email(share_user, owner_user, payment, relation, locale)
    @share_user = share_user
    @owner_user = owner_user
    @payment = payment
    @relation = relation
    I18n.with_locale(set_locale(locale)) do
      mail(to: @share_user.email, subject: "#{@owner_user.email}  " + t(:share_email, :account => @payment.payment_name))
    end
  end

  def owner_receive_delete_email(share_user, owner_user, payment, locale)
    @share_user = share_user
    @owner_user = owner_user
    @payment = payment
    I18n.with_locale(set_locale(locale)) do
      mail(to: @owner_user.email, subject: t(:owner_delete_email, :email => @share_user.email), template_name: "receive_delete_email")
    end
  end

  def sharer_receive_delete_email(share_user, owner_user, payment, locale)
    @share_user = share_user
    @owner_user = owner_user
    @payment = payment
    I18n.with_locale(set_locale(locale)) do
      mail(to: @share_user.email, subject: t(:sharer_receive_delete_email, :email => @owner_user.email), template_name: "receive_delete_email")
    end
  end

  def set_locale(locale)
    if ["en", "zh-TW","zh"].include?( locale )
      return locale
    else
      return "en"
    end
  end
end