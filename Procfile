web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
worker: bundle exec rails solid_queue:work
dispatcher: bundle exec rails solid_queue:dispatch