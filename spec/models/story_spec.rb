require 'rails_helper'

RSpec.describe Story, type: :model do 
  describe "validations" do 
    %i[title text score hn_id].each do |attr|
      it { should validate_presence_of(attr) }
    end

    it { should validate_inclusion_of(:type).in_array(%w[story]) }
    it { should validate_uniqueness_of(:hn_id) }
  end
end