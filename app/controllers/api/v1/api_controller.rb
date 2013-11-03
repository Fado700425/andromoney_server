class Api::V1::ApiController < ApplicationController

  def deal_params
    unless params[:body]
      render :status=>404, :json=>{:message=>"Create Fail"}
      return
    end

    body_params = JSON.parse(params[:body].to_json,:symbolize_names => true)
    body_params
  end
end