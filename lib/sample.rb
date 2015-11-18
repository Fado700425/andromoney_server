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
    category = Fabricate(:category, user: sample_user)
    category.type = type
    category.save
    categories[type] << category
    subcategory = Fabricate(:subcategory, user: sample_user, id_category: category.hash_key)
    subcategory.id_category = category.hash_key
    subcategory.save
    subcategories[type] << subcategory
  end
end

projects = []
10.times do
  projects << Fabricate(:project, user: sample_user)
end

payees = []
10.times do
  payees << Fabricate(:payee, user: sample_user)
end

100.times do
  currency_code = Currency.all.to_a.sample.currency_code
  category = categories[20].sample
  subcategory = Subcategory.where(id_category: category.hash_key).first
  if [true, false].sample
    in_payment = Fabricate(:payment, user: sample_user)
  end
  if in_payment.nil?
    out_payment = Fabricate(:payment, user: sample_user)
  elsif [true, false].sample
    out_payment = Fabricate(:payment, user: sample_user)
  end

  if not in_payment.nil? and out_payment.nil?
    category = categories[10].sample
  elsif in_payment.nil? and not out_payment.nil?
    category = categories[20].sample
  elsif not in_payment.nil? and not out_payment.nil?
    category = categories[30].sample
  end

  is_transfer = in_payment && out_payment
  if is_transfer
    in_amount = Faker::Number.between(100, 10000)
    in_currency = [currency1, currency2, currency3].sample
  end

  subcategory = Subcategory.find_by(user: sample_user, id_category: category.hash_key)
  record = Fabricate(:record, currency_code: currency_code, user: sample_user, category: category.hash_key \
    , subcategory: subcategory.hash_key, in_payment: in_payment.nil? ? nil : in_payment.hash_key\
    , out_payment: out_payment.nil? ? nil : out_payment.hash_key, in_amount: in_amount, in_currency: in_currency)
  record.payee = payees.sample.hash_key
  record.project = projects.sample.hash_key
  record.date = Faker::Time.between(DateTime.now - 10.days, DateTime.now + 10.days)
  record.save
end
