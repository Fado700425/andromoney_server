class Announcement < ActiveRecord::Base
  self.per_page = 8

  scope :categories, -> { select(:category).uniq.pluck(:category) }

  scope :category, -> (category) do
    category.present? ? where(category: category) : all
  end

  scope :locale, -> (locale) do
    locale == :zh ? where(locale: 'zh-TW') : where(locale: locale)
  end
end
