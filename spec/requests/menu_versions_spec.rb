require 'rails_helper'

RSpec.describe "MenuVersions", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/menu_versions/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/menu_versions/index"
      expect(response).to have_http_status(:success)
    end
  end

end
