# frozen_string_literal: true

require_relative "lib/board_game_prototyper/version"

Gem::Specification.new do |spec|
  spec.name = "board_game_prototyper"
  spec.version = BoardGamePrototyper::VERSION
  spec.authors = ["crimsonknave"]
  spec.email = ["crimsonknave@gmail.com"]

  spec.summary = "Quickly create board game prototypes"
  spec.description = "Declare the contents of your game in files, then generate images and a full Tabletop Simulator save file."
  spec.homepage = "https://github.com/lazy-scrivener-games/board_game_prototyper"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activemodel", "~> 7.0.4"
  spec.add_dependency "activesupport", "~> 7.0.4"
  spec.add_dependency "imgkit", "~> 1.6.2"
  spec.add_dependency "easystats", "~> 0.5.0"
  spec.add_dependency "handlebars-engine", "~> 0.3.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
