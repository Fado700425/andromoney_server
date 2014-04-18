class Api::V1::AdsController < Api::V1::ApiController
  skip_before_filter  :verify_authenticity_token

  def index
    ads = Ad.all
    render :status=>200, :json=> ads
  end

  def click
    params = deal_params
    click = AdClick.find_by(email: params[:email],uuid: params[:uuid], ad_id: params[:ad_id])
    if click
      click.update_attribute(:click_times, click.click_times + 1)
    else
      click = AdClick.create(email: params[:email], uuid: params[:uuid], ad_id: params[:ad_id], click_times: 1)
    end

    render :status=>200, :json=>{:message=>"Click Success"}
  end
end