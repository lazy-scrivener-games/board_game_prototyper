# frozen_string_literal: true

require 'imgkit'

class Deck < Collection
  def_delegators :card, :back_path

  alias cards components
  alias card component

  validate :deck_size

  def initialize(attributes = {})
    @component_type = 'card'
    set_rotations
    super
    @component_base_class = Card
    @view_name = 'deck'
    @tts_name = 'Deck'
  end

  def set_rotations
    @rot_x ||= 0
    @rot_y ||= 180
    @rot_z ||= 180
    nil
  end

  def deck_size
    # TTS always wants at least 2x2
    errors.add(:cards, "a deck must have at least 4 cards not #{cards.size}") if cards.size < 4
    errors.add(:cards, "a deck may have no more than 70 cards not #{cards.size}") if cards.size > 70
  end

  def row_size
    if cards.size < 11
      (cards.size.to_f / 2).floor
    else
      10
    end
  end

  def row_count
    (cards.size.to_f / row_size).ceil
  end

  def create_images
    puts 'creating images'
    card.create_back
    create_sheet
  end

  def create_sheet
    target = image_path('deck', config: false)
    return target if File.exist?(target)

    # html = CardsController.render('cards/deck', assigns: { deck: self, image: true })
    handlebars = Handlebars::Engine.new
    handlebars.register_partial(:card, card.handlebars_template)
    template = File.read(File.join(File.dirname(__FILE__), '..', '..', 'assets', 'deck.html'))
    ### TODO: Convert object to hash before passing? it's not being converted atm
    ### Followup, either make compute store in instance variables, or add to a list that also go in attributes
    html = handlebars.compile(template).call(cards: cards.map(&:attributes), image: true)
    File.write(File.join(game.config_path, "output", "deck.html"), html)

    puts "Creating Deck sheet for #{name} #{guid}"
    puts target
    kit = IMGKit.new(html, width: card.width * row_size, height: card.height * row_count)
    # kit = IMGKit.new(html, width: 1970)
    # Do I need to shell out to imagemagik to crop this?
    # kit.stylesheets << "public/assets/#{Rails.application.assets['card.css'].digest_path}"
    kit.stylesheets << File.join(game.config_path, 'assets', 'card.css')
    kit.to_file(target)
  end

  def tts_config
    config = super
    config[:HideWhenFaceDown] = true
    config[:DeckIDs] = cards.map(&:id)
    config[:CustomDeck] = {
      id.to_s => {
        FaceURL: "file://#{image_path('deck', config: true)}",
        BackURL: "file://#{card.image_path('back', config: true)}",
        NumWidth: row_size,
        NumHeight: row_count,
        BackIsHidden: false,
        UniqueBack: false,
        Type: 0
      }
    }
    config[:LuaScript] = ''
    config[:LuaScriptState] = ''

    config
  end
end
