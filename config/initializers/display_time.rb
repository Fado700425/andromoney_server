class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime("%Y-%m-%d %l:%M:%S")
  end
end