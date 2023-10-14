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
    @tags = self.class.tags if self.class.respond_to? :tags

    set_fields
    # TODO: Can we combine the new_component_id method with adding to the components array?
    # @game.components << self

    @hands ||= true
  end

  def to_s
    # if respond_to? :components
    if is_a? Collection
      "#{self.class}: #{name}, components: #{components.size}"
    else
      "#{self.class}: #{name}"
    end
  end

  def inspect
    to_s
  end

  # TODO: Merge this with `attributes` in DSL and just have a flag?
  def recursive_attributes(skip_components = nil)
    values = {}
    attributes.each do |name, value|
      next if %w[errors handlebars_template].include?(name)
      next if name == 'components' && skip_components

      object = instance_variable_get("@#{name}")


      if object.is_a? Array
        object.each do |item|
          values[name] = if item.respond_to? 'recursive_attributes'
                           item.recursive_attributes(skip_components = true)
                         elsif item.is_a? Proc
                           instance_eval(&item)
                         else
                           item
                         end
        end
      end

      values[name] = if object.respond_to? 'recursive_attributes'
                       object.recursive_attributes(skip_components = true)
                     elsif object.is_a? Proc
                       instance_eval(&object)
                     else
                       value
                     end
    end
    values
  end

  def generate_guid(attributes)
    attributes[:game] = "#{attributes[:game].name}-#{attributes[:game].version}"
    attributes[:collection] = collection&.id
    attributes[:id] = @id

    @guid ||= Digest::SHA1.hexdigest(attributes.to_s)[0..5]
    @guid
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
        r:,
        g:,
        b:
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

  # TODO: Config true uses output path and config false uses config path?
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
    File.join(path, "#{name.gsub(" ", "_").downcase}_#{ending}-#{guid}.png")
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
