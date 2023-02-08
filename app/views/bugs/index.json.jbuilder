json.array!(@bugs) do |bug|
  json.extract! bug, :id, :title, :name, :email, :text
  json.url bug_url(bug, format: :json)
end
