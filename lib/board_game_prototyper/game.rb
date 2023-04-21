# frozen_string_literal: true

require 'set'
require 'active_model'
require 'active_support/core_ext/hash/indifferent_access'
require 'board_game_prototyper/component'
require 'board_game_prototyper/collection'
require 'board_game_prototyper/components'

require 'json'
require 'fileutils'

# CIDEr integration plan
# CIDEr export and import a json database that uses dexie, which is a wrapper around the browsers indexeddb
# There doesn't seem to be an existing ruby library for this, but it's not complicated
# We should be able to generate/modify the database json file from the game model
#
# TODO: Determine what is defined here, and what is defined in CIDEr
# Decks/cards - here
# HTML/css - cider
# Images - could do cider, they have a tts export mode, but it looked like it had some spacing issues
#          or, we could render images via cider and merge them ourselves, or we could read the handlebars
#          and parse the css and render it all ourselves
#
#          I'm leaning towards using cider to design, template and so on and rendering all the html directly
#          in the app and using the existing sheet structure.
# Commands
#   Load game config files - This is the current flow
#   Load cider database - This would use the cider database for all card data
#   Generate cider directory structure (attributes.csv, back.css ...)
#     Options to touch or not touch the css and html
#
#   Save to tts
#   Save to cider
#   Update existing cider database with new card content
#
# CSS doesn't quite match in cider with my base stuff
#   Had to add color black, text box goes off the edge of the card
#
#
# Notes:
# box-sizing is enforced overall in cider, anything else I care about?
# updated css to use box-sizing so they render right in cider
# need to create csv dumps for cider as things like costs are calculated from resources to include the non zero
# need to script up syncing the css and scss and so on
# deck needs to have a cider config generator which
#   creates a folder, dumps cards.csv, attributes.csv, and front and back css and html
# game then creates a folder with the game name and dumps the decks and assets (if any)
# So you can generate a full cider project from a game. Then you can tweak in cider and we will render from the cider files
# Rendering the cider files will mean we have to use handlebars and run off the cider csv files. So we'll want a step that generates new csv files from the base game config if needed without touching the rest.


class Game
  include ActiveModel::Model
  include BoardGamePrototyper::Dsl
  extend Forwardable
  def_delegators :@components, :each, :<<

  set_attrs(:components, :name, :base_save, :new_save, :version, :output_path, :tts_save_path, :cider_path, :config_path)

  validate :all_guids_unique_and_present

  def initialize(attributes = {})
    attributes = attributes.with_indifferent_access
    @next_component_id = 0
    @components = []
    @config_path = File.expand_path(File.dirname($0))

    # config = JSON.parse(File.read(File.join(@path, @config_file)))
    components_config = attributes.delete('components')
    super(attributes)
    load_components(components_config)

  end

  def to_s
    "Game: #{name},  components: #{components.size}"
  end

  def inspect
    to_s
  end

  # TODO this should be shared with component, not copied
  def recursive_attributes(skip_components=nil)
    puts '=======,,,,,'
    puts 'recursive'
    puts name
    values = {}
    attributes.each do |name, value|
      next if ['errors', 'handlebars_template'].include?(name)
      next if name == 'components' && skip_components
      puts '*******'
      puts value.class
      object = instance_variable_get("@#{name}")
      puts name
      puts object.class
      if object.is_a? Array
        puts '*******array'
        if object.respond_to? 'recursive_attributes'
          puts 'yes'
          values[name] = object.recursive_attributes
        else
          values[name] = value
        end
        puts '------done'
      end

      if object.respond_to? 'recursive_attributes'
        puts 'yes'
        values[name] = object.recursive_attributes
      else
        values[name] = value
      end
    end
    values
  end

  def save_target
    File.join(@config_path, @new_save)
  end


  def new_component_id
    return @next_component_id += 1
  end

  def all_guids_unique_and_present
    guids = components.map(&:guids).flatten
    present_guids = guids.compact
    errors.add(:guid, 'Every component must have a guid') if present_guids.size < guids.size
    unique_guids = present_guids.to_set
    errors.add(:guid, "All GUIDs must be unique, duplicate GUIDs found #{present_guids.sort}") if unique_guids.size < present_guids.size
  end

  def load_components(components)
    components.each do |component|
      if component.is_a? String
        Dir.glob(File.join(@config_path, component)).each do |file|
          load_component(JSON.parse(File.read(file)))
        end
      else
        load_component(component)
      end
    end
  end

  def guid
    'game'
  end

  def load_component(config)
    return if config['disabled']

    klass = config.delete('type').gsub(' ', '_').classify.constantize
    config[:id] = @components.size + 1
    config[:game] = self

    instance = klass.new(**config)
    raise "Component #{instance} is invalid: #{instance.errors.messages}" if instance.invalid?

    @components << instance
  end

  def tts_config
    config = JSON.parse(File.read(File.join(@config_path, @base_save))).with_indifferent_access
    config[:SaveName] = "#{name} - #{`date`}".strip
    puts components
    config[:ObjectStates].concat(components.map(&:tts_config))

    FileUtils.mkdir_p(File.join(save_target.split('/')[0..-2]))
    File.write(save_target, JSON.dump(config))
    puts "TTS Save #{save_target} generated"

    return unless tts_save_path

    FileUtils.mkdir_p(File.join(tts_save_path, name))
    target = File.join(tts_save_path, name, "#{name} #{version}.json")
    FileUtils.cp(save_target, target)
    puts "Copied new save to #{target}"
  end
end
