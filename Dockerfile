###
# This docker file provides a consistent environment for running the
# project locally. See the "Docker" section of README.md for more information
###
FROM ruby:3.4

EXPOSE 8000

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential rsync git curl \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# The following is run each time the container is "run"
CMD echo "No command provided, you should be using run_dev.sh"
