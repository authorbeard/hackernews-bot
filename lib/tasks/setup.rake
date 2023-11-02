namespace :setup do 
  desc 'install dependencies' 
  task bundle_install: :environment do
    system("bundle install")
  end

  desc 'create databases and run migrations' 
  task create_dbs: :environment do 
    system("bundle exec rails db:setup")
  end

  desc 'get first set of stories and comments'
  task seed_stories: :environment do 
    FetchTopStoriesJob.perform_later 
  end

  desc 'perform complete setup' 
  task complete_install: :environment do
    Rake::Task['setup:bundle_install'].invoke
    Rake::Task['setup:create_dbs'].invoke
    Rake::Task['setup:seed_stories'].invoke
  end
end