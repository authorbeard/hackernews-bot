require 'net/http'

class HackerNewsClient 
  BASE_URL = "https://hacker-news.firebaseio.com/v0"

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

      # NOTE: limiting to 20 on the assumption that it'll yield at least 10 stories of type 'story'; haven't 
      # yet examined this to see if the topstories endpoint includes jobs and other things. 
      # the default is 500; it's just an array of ids, so that's not a ton of data to have to deal with, but still seems like overkill. 
      # also, the pattern I usually follow is to memoize a base set of params/queries/headers what-have-you and then merge those with 
      # endpoint- or method-specific params/queries/headers, but it doesn't seem like that'll be necessary here, so for now, I'm just doing 
      # this within the metho. 
      uri.query = URI.encode_www_form({ orderBy: "$key".to_json, limitToFirst: 20 })

      # NOTE: Considered memoizing this, but I'm not sure we'll actually need that 
      JSON.parse(Net::HTTP.get(uri))
    end

    def get_story(id)
      uri = URI("#{BASE_URL}/item/#{id}.json")
      JSON.parse(Net::HTTP.get(uri))

    end
  end
end