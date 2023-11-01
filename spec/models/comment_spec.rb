require 'rails_helper'

RSpec.describe Comment do 
  describe "validations" do 
    %i[text hn_id].each do |attr|
      it { should validate_presence_of(attr) }
    end

    it { should validate_inclusion_of(:hn_type).in_array(%w[comment]) }

    it 'is invalid without a parent story' do 
      comment = FactoryBot.build(:comment, story: nil)
      expect(comment).not_to be_valid
    end
  end
end