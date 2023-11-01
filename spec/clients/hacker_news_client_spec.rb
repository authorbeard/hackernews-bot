require 'rails_helper'

RSpec.describe HackerNewsClient do
  before do 
    stub_request(:get, "https://hacker-news.firebaseio.com/v0/topstories.json?limitToFirst=20&orderBy=%22$key%22").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Host'=>'hacker-news.firebaseio.com',
      'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "[38099086,38097184,38097031,38097984,38100284,38098740,38097724,38096955,38095699,38098647,38098490,38095276,38097769,38097142,38099506,38097858,38096958,38063687,38099823,38097121]", headers: {})
  end

  # NOTE: force of habit to start writing tests here. I'm not sure that I'll need to test this class at all; it doesn't 
  # do much that isn't already either standard-library stuff or out of our control (HN's API behavior)
  # leaving this here for now so that if/when I change my mind, I have some test scaffolding set up. 
  describe '.get_top_stories' do
    subject { described_class.get_top_stories }

    it 'returns an array of ids for the top 20 stories' do
      expect(subject).to be_an(Array)
      expect(subject.first).to be_an(Integer)
    end
  end
end