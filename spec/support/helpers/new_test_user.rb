module NewTestUser
   
  def create_user(email, name, id)
    Fabricate(:user, email: email, name: name, id: id) 
  end

  def set_user_assest(usr)
    in_category  = Fabricate.times(15, :category, type: 10, user: usr)
    out_category = Fabricate.times(15, :category, type: 20, user: usr)
    tra_category = Fabricate.times(15, :category, type: 30, user: usr)

    in_subcategory = Array.new
    in_category.each do |i|
      in_subcategory << Fabricate.times(25, :subcategory, id_category: i.hash_key, user: usr)
    end

    out_subcategory = Array.new
    out_category.each do |o|
      in_subcategory << Fabricate.times(25, :subcategory, id_category: o.hash_key, user: usr)
    end

    traSubcategory = Array.new
    tra_category.each do |t|
      in_subcategory << Fabricate.times(25, :subcategory, id_category: t.hash_key, user: usr)
    end

    tw_cash = Fabricate(:payment, user: usr, currency_code: "TWD", kind: 0)
    tw_card = Fabricate(:payment, user: usr, currency_code: "TWD", kind: 1)
    tw_bank = Fabricate(:payment, user: usr, currency_code: "TWD", kind: 2)
    us_cash = Fabricate(:payment, user: usr, currency_code: "USD")
    eu_cash = Fabricate(:payment, user: usr, currency_code: "EUR")

    payee   = Fabricate.times(12, :payee, user: usr)
    project = Fabricate.times(12, :project, user: usr)
  end
end