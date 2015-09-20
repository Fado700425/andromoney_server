class PaymentCell < Cell::ViewModel
  cache :show do |user, icon_path, countIn|
    nCountIn = countIn ? 0 : 1
    latestPayment = Payment.select(:update_time).where("user_id = #{user.id} and ifnull(out_total,0) = #{nCountIn}").order('update_time DESC').limit(1)
    #latestRecord = Record.select(:update_time).where(user_id: user.id, 
    #  in_payment: Payment.where("user_id = #{user.id} and ifnull(out_total,0) = #{nCountIn}")).order('update_time DESC').limit(1)
    byebug
    latestRecord = Record.select(:update_time)
      .where("user_id = #{user.id} and (WHERE 'record_table'.'in_payment' IN (Select 'payment_table'.'hash_key' where user_id = #{user.id} and ifnull(out_total,0) = #{nCountIn}) OR WHERE 'record_table'.'out_payment' IN (Select 'payment_table'.'hash_key' where user_id = #{user.id} and ifnull(out_total,0) = #{nCountIn}))")
      .order('update_time DESC').limit(1)    

    # use this SELECT COUNT(count_column) FROM (SELECT `record_table`.`update_time` AS count_column FROM `record_table` WHERE (user_id = 9 and ( `in_payment` IN (Select `hash_key` from `payment_table` where user_id = 9 and ifnull(out_total,0) = 0) OR `record_table`.`out_payment` IN (Select `hash_key` from `payment_table` where user_id = 9 and ifnull(out_total,0) = 0))) LIMIT 1) subquery_for_count

    if(latestPayment.size == 1)
      paymentKey = latestPayment[0].update_time.strftime("%Y%m%d%H%M%S")
    else
      paymentKey = 'PAYMENT_EMPTY'
    end

    if(latestRecord.size == 1)
      recordKey = latestRecord[0].update_time.strftime("%Y%m%d%H%M%S")
    else
      recordKey = 'RECORD_EMPTY'
    end
    user.id.to_s + paymentKey + recordKey + user.get_main_currency.currency_code +
    countIn ? 'CountIn' : 'NotCount'
  end

  def show(user, icon_path, countIn)
    @payments = Payment.where("user_id = #{user.id} and ifnull(out_total,0) = #{countIn ? 0 : 1}").not_hidden.order("order_no")
    @user = user
    @icon_path = icon_path
    render
  end
end