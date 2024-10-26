# Dockerfile
FROM ruby:3.1

# Set working directory
WORKDIR /app

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Install Node.js and Yarn
RUN apt-get update -qq && \
    apt-get install -y nodejs npm && \
    npm install -g yarn

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 8080

# Start the Rails server
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
