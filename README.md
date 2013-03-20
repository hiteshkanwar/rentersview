
Renters View


Installation Instructions
------------------------

Setup database:

```bash
cp config/database.yml.example config/database.yml
bundle exec rake db:create
bundle exec rake db:schema:load
```

Add credentials for services: (https://devcenter.heroku.com/articles/config-vars)

```bash
cp .env.example .env
cp Procfile Procfile.example
```

Running the app:
* Rails server
* Sunspot process

```bash
foreman start
```

Reindexing the data:
```bash
rake sunspot:reindex
```

rentersview

