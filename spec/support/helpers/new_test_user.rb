module NewTestUser
   
  def create_user(email, name, id)
    Fabricate(:user, email: email, name: name, id: id) 
  end

  def set_user_assest(usr)
    # * * * * * random generated samples * * * * *
    in_category  = Fabricate.times(10, :category, type: 10, user: usr)
    out_category = Fabricate.times(10, :category, type: 20, user: usr)
    tra_category = Fabricate.times(10, :category, type: 30, user: usr)

    in_category.each do |i|
      Fabricate.times(10, :subcategory, id_category: i.hash_key, user: usr)
    end
    out_category.each do |o|
      Fabricate.times(10, :subcategory, id_category: o.hash_key, user: usr)
    end
    tra_category.each do |t|
      Fabricate.times(10, :subcategory, id_category: t.hash_key, user: usr)
    end

    Fabricate.times(10, :payee, user: usr)
    Fabricate.times(10, :project, user: usr)
    Fabricate.times(2, :payment, user: usr, currency_code: 'TWD')

    Fabricate(:currency, currency_code: 'TWD', rate: 28.5, currency_remark: 'New Taiwan Dollar', sequence_status: 0, flag_path: 'Taiwan.png', user: usr)
    Fabricate(:currency, currency_code: 'USD', rate: 1, currency_remark: 'US Dollar', sequence_status: 2, flag_path: 'America.png', user: usr)
    Fabricate(:currency, currency_code: 'EUR', rate: 0.75, currency_remark: 'Euro', sequence_status: 1, flag_path: 'Europe.png', user: usr)

    # * * * * * generated targets * * * * *
    Fabricate(:payment, user: usr, currency_code: 'TWD', kind: 2, payment_name: 'Taishin Bank')
    Fabricate(:payment, user: usr, currency_code: 'USD', kind: 1, payment_name: 'Bank of America')
    Fabricate(:payment, user: usr, currency_code: 'EUR', kind: 0, payment_name: 'Deutsch Bank')

    stock = Fabricate(:category, user: usr, type: 10, category: 'stock investment')
    Fabricate(:subcategory, subcategory: "Buffet's choice", id_category: stock.hash_key, user: usr)
    Fabricate.times(10, :subcategory, id_category: stock.hash_key, user: usr)

    elect = Fabricate(:category, user: usr, type: 20, category: 'Electronics Equ')
    Fabricate(:subcategory, subcategory: "Apple's best", id_category: elect.hash_key, user: usr)
    Fabricate.times(10, :subcategory, id_category: elect.hash_key, user: usr)

    lover = Fabricate(:category, user: usr, type: 30, category: 'To my lover')
    Fabricate(:subcategory, subcategory: "miss Gina", id_category: lover.hash_key, user: usr)
    Fabricate.times(10, :subcategory, id_category: lover.hash_key, user: usr)

    Fabricate(:payee, payee_name: "Amazon", user: usr)
    Fabricate(:project, project_name: "Business", user: usr)

  end
end