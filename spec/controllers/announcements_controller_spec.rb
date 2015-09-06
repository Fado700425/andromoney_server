require 'spec_helper'

describe AnnouncementsController do
  let!(:announcement) do
    Announcement.create([
      { title: "Taiwan", category: 'Web', locale: 'zh-TW' },
      { title: "America", category: 'Web', locale: 'en' },
      { title: "Japan", category: 'Web', locale: 'ja' },
    ])
  end

  before (:all) { I18n.locale = nil }

  context 'GET #index' do
    render_views

    it 'locale en' do
      get :index, locale: 'en'
      expect(response.body).to include('America')
      expect(response.body).to_not include('Taiwan', 'Japan')
    end

    it 'locale ja' do
      get :index, locale: 'ja'
      expect(response.body).to include('Japan')
      expect(response.body).to_not include('Taiwan', 'America')
    end

    it 'locale zh-TW' do
      get :index, locale: 'zh-TW'
      expect(response.body).to include('Taiwan')
      expect(response.body).to_not include('America', 'Japan')
    end
  end
end
