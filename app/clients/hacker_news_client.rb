require 'net/http'

class HackerNewsClient 
  BASE_URL = "https://hacker-news.firebaseio.com/v0"
  class APIError < StandardError; end

  # NOTE: At the moment, I don't see much of a need to instantiate a class of the client; it's going to know how to interface with 
  # HN and next to nothing else. It will be the responsibility of another class to make the appropriate requests from the client. 
  # Expecially considering that I haven't yet found a way to query on multiple items, filtering by type='story' and ordering by 
  # score, which is how I'd expect to be able to do this type of thing. 
  class << self
    def get_top_stories
      # NOTE: If there's a way to get and inspect item objects including their types without going through each, 
      # then I haven't found it yet. So we'll need to hit this endpoint to get the top stories, then request each
      # one individually and inspect its type. 
      uri = URI("#{BASE_URL}/topstories.json")

      # NOTE: Commenting this out for now, as I can't be confident in what orderBy does to the results. HackerNews has not
      # documented the order in which these are returned, as far as I know, but my initial concern over having to deal with 500 items
      # proved unfounded, as they're just IDs, and the service that calls this method stops calling the individual one 
      # it has reached 10 stories anyway. 
      # uri.query = URI.encode_www_form({ orderBy: "$key".to_json, limitToFirst: 20 })

      # NOTE: Considered memoizing this, but I'm not sure we'll actually need that 
      resp = Net::HTTP.get_response(uri)
      raise APIError.new("Error fetching top stories: #{resp}") unless resp.is_a?(Net::HTTPSuccess)

      JSON.parse(resp.body)

    rescue Errno::ETIMEDOUT, Net::OpenTimeout => e
      raise APIError.new("Connection timeout error")
    end

    def get_story(id)
      uri = URI("#{BASE_URL}/item/#{id}.json")
      JSON.parse(Net::HTTP.get(uri))
    end
  end
end