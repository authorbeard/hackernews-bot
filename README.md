# README

Welcome to the HackerNews Bot. 

It does the following things: 

- Shows the top ten stories on HackerNews, as defined by them and returned by the `/topstories` endpoint. 
 - It only displays items with a `type` attribute that equals `story`. Sometimes `jobs` or other types sneak into that list. 
- Togles the display of every story's comments, if any. 
- Preserves the original link posted to HackerNews, or links to the the main site if no URL is present on an individual story. 
- Checks every hour to see if there have been any changes to the top ten. 

### Requirements

- ruby 3.2.0
- rails 7.0.8
- postgresql 14
- redis 7.2.1
- sidekiq 7.2.0

If you're reading this, I trust you to be able to figure out how to install/upgrade as needed. 

### Install/Setup

Once you've cloned down the repo, you can do the usual Rails dance, or you can just use this: 

```
bundle exec rails setup:complete_install 
```  

That'll install all your gems, set up your databases, and enqueue a job that will retrieve the top 10 stories and enqueue further jobs to request each story's comments from the HackerNews API. (Well, it'll actually shove the job up into the redis queue, but Sidekiq will pick it up from there when it starts). 

To start it up, it's dealer's choice whether to use `bin/dev` or `be foreman s`. Both Procfiles are the same. 

That's really all there is to it. The hourly refresh is scheduled in `config/initializers/sidekiq`:  

```
  config.on(:startup) do
    Sidekiq.set_schedule(
      'FetchTopStoriesJob',
      {
        'every': '1h',
        'class': 'FetchTopStoriesJob'
      }
    )
  end
``` 

That bit of handiness comes via the `sidekiq-scheduler` gem, which makes scheduling easy and saves you the money of buying a Pro or Enterprise license for Sidekiq. That's useful for a little project like this. Less so for real-deal production code. But that's not our concern right now. 


### Other Stuff  

- This really only has the one view, and it's the root (`stories#index`). In fact I'm not even handling HTML in other things, like `CommentsController`. Again, this was to save time and focus on the acceptance criteria as I understood them. 
- The service that fetches stories fires off, at minimum, n+1 requests, where n is the number of top stories. That's because `/topstories` actually only returns a list of item IDs, and if there's a way to make it cough up more/better info, I haven't found it. 
 - 	So that means 1 query to get the list, then 1 query/id to get that story. 
 - The good news here is that at least [The Firebase Docs](https://firebase.google.com/docs/database/rest/retrieve-data#section-rest-filtering) show how to limit the number of items returned; the default is 500.  
 - That's probably not such a big deal. A JSON array of 500 integers isn't going to be *that* much heavier than this app's default (20), especially since the service that handles the import stops querying the API once it's found 10 no-foolin' story-type stories. 
 - Considering that Firebase requires an `orderBy` query param before you can even limit the number of items coming back, this might explain some weirdness in the data order. So if you look at this and can't find that default mentioned up above, it's because I kept tinkering and just removed it. 
- The test coverage is woefully insufficient. I was short on time for this and focused on meeting the acceptance criteria. But rest assured I am embarrassed about that. 
- If, at any time, you want to kick off a fresh import instead of waiting for the next hour, there's a task for that:  

  ```
  bundle exec rails top_stories:fetch_now
  ```  
- You can also schedule the fetch job yourself, if you want to for any reason. The code's in `lib/tasks/top_stories.rake` and [The readme for sidekiq-scheduler](https://github.com/sidekiq-scheduler/sidekiq-scheduler) contains some interesting options for adjusting the timing and such.  
 - You could also schedule the comments refresh job. It's called `FetchStoryCommentsJob`, and that's what you'd slap into that rake file to schedule this one instead of the main event, `FetchTopStoriesJob`.  
- This uses TailwindCSS, Stimulus and Turbo. Not particularly impressively, but they're there. It was my first time through all of them. And when it comes to visual design, let alone figuring out the CSS to achieve it, I've long realized that's just not a strength for me. 
- Error handling for the requests has been delegated to Sidekiq here. If you visit `localhost:3000/sidekiq` you can see the dashboard, with its 'Dead' tab. That's also available at [localhost:3000/morgue](http://localhost:3000/morgue)
- I've left the commit's un-squashed in case you want to walk through them. Each individual commit has a descriptive message, though I did not take the trouble to write up something in the Github commit description field. I usually do, but like I said, I was pressed for time here. 

