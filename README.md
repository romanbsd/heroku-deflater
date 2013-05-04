# heroku-deflater

A simple rack middleware that enables compressing of your assets and application
responses on Heroku, while not wasting CPU cycles on pointlessly compressing images
and other binary responses.

It also includes code from https://github.com/mattolson/heroku_rails_deflate

Before serving a file from disk to a gzip-enabled client, it will look for
a precompressed file in the same location that ends in ".gz".
The purpose is to avoid compressing the same file each time it is requested.

## Installing

Add to your Gemfile:

    gem 'heroku-deflater', :group => :production


## Contributing to heroku-deflater

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Roman Shterenzon. See LICENSE.txt for
further details.

[1]: https://github.com/rack/rack/issues/349
