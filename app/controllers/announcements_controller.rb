class AnnouncementsController < ApplicationController
  
  def index
    @categories = Announcement.locale(I18n.locale).categories
    @announcements = Announcement.locale(I18n.locale)
                                 .category(params[:category])
                                 .paginate(page: params[:page])
                                 .order(created_at: :desc)
  end
end
