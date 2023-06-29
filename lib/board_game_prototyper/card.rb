# frozen_string_literal: true

require 'imgkit'
require 'handlebars-engine'

class Card < Component
  include ActiveModel::Model
  set_attrs :front, :back, :name, :handlebars_template, :deck, :back_name

  def initialize(attributes = {})
    super
    @front ||= 'standard_card'
    @back ||= 'back'
    @multiplier = 2
    ensure_lists
    @images = true
    @view_name = '_card'
    @tts_name = 'Card'
    @handlebars_template = File.read(File.join(game.config_path, 'assets', 'card.html'))
    @deck = @collection
    @back_name = @collection.name
  end

  def ensure_lists
    @types = @types.split(',').map { |x| x.strip } if @types.is_a? String
  end

  def boxes
    0
  end

  def width
    # 197
    250 * @multiplier
  end

  def height
    # 335
    350 * @multiplier
  end

  def create_images
    return if collection
    create_back
    create_front
  end

  def create_back
    # TODO: Do we actually need to pass config somewhere for a real reason
    # AKA, is this a Chesterton's Fence?
    target = image_path('back', config: false)
    return target if File.exist?(target)

    puts "Creating back image for #{name} #{guid}"
    puts collection.class
    # html = CardsController.render "cards/_#{back}", locals: { card: self, image: true, side: :back, solo: true }
    handlebars = Handlebars::Engine.new
    template = File.read(File.join(game.config_path, 'assets', 'back.html'))
    # TODO: `recursive_attributes` here? Why did I add the methods, they're not used...
    html = handlebars.compile(template).call(card: attributes, image: true, side: :back)
    kit = IMGKit.new(html, height: height, width: width)
    # kit.stylesheets << "public/assets/#{Rails.application.assets['solo_card.css'].digest_path}"
    kit.stylesheets << File.join(game.config_path, 'assets', 'card.css')
    kit.to_file(target)

    target
  end

  def tts_config
    config = super
    config[:CardID] = id
    config[:ContainedObjects] = []

    return config if collection

    config[:CardID] = id * 100

    config[:CustomDeck] = {
      id.to_s => {
        FaceURL: "file://#{front_path}",
        BackURL: "file://#{image_path('back', config: true)}",
        NumWidth: 1,
        NumHeight: 1,
        BackIsHidden: false,
        UniqueBack: false,
        Type: 0
      }
    }

    config
  end

  private

  def create_front
    target = image_path(name, config: false)
    return target if File.exist?(target)

    puts "Creating image for #{name} #{guid}"
    # html = CardsController.render "cards/_#{front}", locals: { card: self, image: true, side: :front }
    handlebars = Handlebars::Engine.new
    html = handlebars.compile(handlebars_template).call(card: self, image: true, side: :front)
    kit = IMGKit.new(html, width: width)
    # kit.stylesheets << "public/assets/#{Rails.application.assets['solo_card.css'].digest_path}"
    kit.stylesheets << File.join(game.config_path, 'assets', 'card.css')
    kit.to_file(target)

    target
  end
end
