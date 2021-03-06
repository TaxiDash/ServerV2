json.array!(@services) do |service|
  json.extract! service, :id, :start_latitude, :start_longitude, :end_latitude, :end_longitude, :start_time, :end_time, :estimated_cost, :actual_cost
  json.url service_url(service, format: :json)
end
