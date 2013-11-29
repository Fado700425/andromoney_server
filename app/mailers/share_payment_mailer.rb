class SharePaymentMailer < ActionMailer::Base
  default from: 'service@andromoney.com'

  def share_email(share_user, owner_user, payment, relation)
    @share_user = share_user
    @owner_user = owner_user
    @payment = payment
    @relation = relation
    mail(to: @share_user.email, subject: "#{@owner_user.email} 想跟你分享帳戶資料")
  end

  def owner_receive_delete_email(share_user, owner_user, payment)
    @share_user = share_user
    @owner_user = owner_user
    @payment = payment
    mail(to: @owner_user.email, subject: "已取消你分享給#{@share_user.email} 帳戶資料")
  end

  def sharer_receive_delete_email(share_user, owner_user, payment)
    @share_user = share_user
    @owner_user = owner_user
    @payment = payment
    mail(to: @share_user.email, subject: "#{@owner_user.email} 已取消跟你分享帳戶資料")
  end
end