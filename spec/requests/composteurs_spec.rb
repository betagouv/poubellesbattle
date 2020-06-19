require 'rails_helper'

RSpec.describe "Composteurs", type: :request do
  describe "GET /composteurs" do
    it "works! (now write some real specs)" do
      get composteurs_index_path
      expect(response).to have_http_status(200)
    end
  end
end
