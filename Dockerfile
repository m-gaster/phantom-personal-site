# Use the official Ruby image
FROM ruby:3.2-slim

# Install dependencies
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && apt-get install -y --fix-missing build-essential git

# Set up Jekyll directory
WORKDIR /usr/src/app

# Copy the Gemfile and Gemfile.lock (if exists)
COPY Gemfile Gemfile.lock phantom.gemspec ./

# Install Bundler and Jekyll dependencies
RUN gem install bundler && bundle install

# Copy all site files
COPY . .

# Expose Jekyll's default port
EXPOSE 4000

# Run Jekyll serve command
CMD ["bundle", "exec", "jekyll", "serve", "--host=0.0.0.0"]

# Alternative version
# FROM ruby:3.1-slim-bullseye as jekyll

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     build-essential \
#     git \
#     && rm -rf /var/lib/apt/lists/*

# # used in the jekyll-server image, which is FROM this image
# COPY docker-entrypoint.sh /usr/local/bin/

# RUN gem update --system && gem install jekyll && gem cleanup

# EXPOSE 4000

# WORKDIR /site

# ENTRYPOINT [ "jekyll" ]

# CMD [ "--help" ]

# # build from the image we just built with different metadata
# FROM jekyll as jekyll-serve

# # on every container start, check if Gemfile exists and warn if it's missing
# ENTRYPOINT [ "docker-entrypoint.sh" ]

# CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]