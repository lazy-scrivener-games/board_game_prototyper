FROM ruby:slim

RUN apt update
RUN apt install -y build-essential
RUN apt install -y ruby-build
RUN apt install -y wkhtmltopdf


RUN mkdir /board_game_prototyper
WORKDIR /board_game_prototyper

COPY Gemfile /board_game_prototyper/Gemfile
COPY Gemfile.lock /board_game_prototyper/Gemfile.lock
COPY board_game_prototyper.gemspec /board_game_prototyper/board_game_prototyper.gemspec
COPY lib/board_game_prototyper/version.rb /board_game_prototyper/lib/board_game_prototyper/version.rb
RUN cat /usr/local/bundle/extensions/x86_64-linux/3.1.0/mini_racer-0.16.0/mkmf.log
RUN bundle install

COPY . /board_game_prototyper

COPY scripts/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
