currency1= Fabricate(:currency, currency_code: 'TWD', sequence_status: 1)
currency2= Fabricate(:currency, currency_code: 'GBP', sequence_status: 2)
currency3= Fabricate(:currency, currency_code: 'AZN', sequence_status: 0)

sample_user = Fabricate(:sample_user)
sample_user.currencies << currency1
sample_user.currencies << currency2
sample_user.currencies << currency3

categories = Hash.new { |h, k| h[k] = [] }
subcategories = Hash.new { |h, k| h[k] = [] }
[10, 20, 30].each do |type|
  5.times do
    category = Fabricate(:category, user_id: sample_user.id)
    category.type = type
    category.save
    categories[type] << category
    subcategory = Fabricate(:subcategory, user_id: sample_user.id)
    subcategory.id_category = category.hash_key
    subcategory.save
    subcategories[type] << subcategory
  end
end



100.times do
  currency_code = Currency.all.to_a.sample.currency_code
  record = Fabricate(:record, currency_code: currency_code, user_id: sample_user.id)
  record.send [:in_payment=, :out_payment=].sample, Fabricate(:payment, user_id: sample_user.id).hash_key
  unless record.in_payment.nil?
    category = categories[10].sample
    subcategory = Subcategory.where(id_category: category.hash_key).first
    record.category = category.hash_key
    record.subcategory = subcategory.hash_key
  end
  unless record.out_payment.nil?
    category = categories[20].sample
    subcategory = Subcategory.where(id_category: category.hash_key).first
    record.category = category.hash_key
    record.subcategory = subcategory.hash_key
  end
  record.date = Faker::Time.between(DateTime.now - 10.days, DateTime.now + 10.days)
  record.save
end

10.times do
  Fabricate(:payee)
  Fabricate(:project)
end