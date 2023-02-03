# frozen_string_literal: true
require 'digest'


class Component
  include ActiveModel::Model
  include BoardGamePrototyper::Dsl

  COORDINATES_FIELDS = %w[x rot_x y rot_y z rot_z]
  COLOR_FIELDS = %w[r g b]
  SCALE_FIELDS = %w[scale_x scale_y scale_z]
  set_attrs(:guid, :id, :name, :game, :view_name, :images, *COORDINATES_FIELDS, *COLOR_FIELDS, *SCALE_FIELDS,
            :collection, :tts_name, :hands, :locked, :tags, :disabled)


  validates :tts_name, presence: true
  validates(*COORDINATES_FIELDS, numericality: true)

  def initialize(attributes = {})
    super
    @id ||= @game.new_component_id
    generate_guid(attributes.with_indifferent_access)
    @images = false
    @tags = {}

    set_fields
    @hands ||= true
  end

  def generate_guid(attributes)
    attributes[:game] = "#{attributes[:game].name}-#{attributes[:game].version}"
    attributes[:collection] = collection&.id
    attributes[:id] = @id
    # TODO: Work up a non rails based version
    # Dir.glob(File.expand_path(File.dirname(__FILE__)).join('app/assets/stylesheets/*')) do |stylesheet|
      # attributes[stylesheet] = Rails.application.assets.find_asset(stylesheet).id
    # end

    @guid ||= Digest::SHA1.hexdigest(attributes.to_s)[0..5]
  end

  def guids
    [guid]
  end

  def create_images
    # Default is to do nothing
  end

  def tts_config
    create_images

    {
      GUID: guid,
      Name: tts_name,
      Transform: {
        posX: x,
        posY: y,
        posZ: z,
        rotX: rot_x,
        rotY: rot_y,
        rotZ: rot_z,
        scaleX: scale_x,
        scaleY: scale_y,
        scaleZ: scale_z
      },
      Nickname: name,
      Description: '',
      GMNotes: '',
      AltLookAngle: {
        x: 0.0,
        y: 0.0,
        z: 0.0
      },
      ColorDiffuse: {
        r: r,
        g: g,
        b: b
      },
      LayoutGroupSortIndex: 0,
      Value: 0,
      Locked: !!locked,
      Grid: true,
      Snap: true,
      IgnoreFoW: false,
      MeasureMovement: false,
      DragSelectable: true,
      Autoraise: true,
      Sticky: true,
      Tooltip: true,
      GridProjection: false,
      Hands: hands,
      XmlUI: ''
    }
    # CardsController.render "tts/#{view_name}", locals: { object: self }
  end

  def image_path(ending, config: false)
    # When running in docker the path for the file won't be the same as
    # the actual location on the host system that the files will be in
    # If the output_path is set to output it will be the same place
    # when running directly with rake
    base_path = if config
                  File.join(game.output_path, 'images')
                else
                  File.join(game.config_path, 'output', 'images')
                end
    # Use the guid as a cache busting mechanism so TTS will pull new versions
    path = File.join(base_path, self.class.to_s.underscore.downcase)
    FileUtils.mkdir_p(path)
    File.join(path, "#{name.gsub(' ', '_').downcase}_#{ending}-#{guid}.png")
  end

  def set_fields
    fields = [COORDINATES_FIELDS, COLOR_FIELDS, SCALE_FIELDS].flatten
    defaults = {
      x: id * 3,
      y: 0,
      z: 0,
      rot_x: 0,
      rot_y: 0,
      rot_z: 0,
      r: 0.71,
      g: 0.71,
      b: 0.71,
      scale_x: 1.0,
      scale_y: 1.0,
      scale_z: 1.0
    }.with_indifferent_access
    fields.each do |field|
      value = instance_variable_get("@#{field}")
      next if value

      value = collection.instance_variable_get("@#{field}") || instance_variable_get("@#{field}") || defaults[field]
      instance_variable_set("@#{field}", value)
    end
  end
end

require 'board_game_prototyper/counter'
