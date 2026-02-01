# frozen_string_literal: true

# Book class
class Book < Collection
  alias entries components
  alias entry component
  set_attrs(:cover, :back)

  validate :no_missing_numbers

  def initialize(attributes = {})
    super
  end

  def generate_pdf; end

  # Delegate dictionary stuff so this class can function like a dictionary

  def [](number)
    lookup = entries.select { |e| e.number == number }
    return lookup.first if lookup

    None
  end

  def tts_config
    generate_pdf
    # then set config to have that file as a book or whatever
  end

  def no_missing_numbers
    return true if entries.empty?

    # collate_entries
    numbers = entries.map(&:number).sort
    previous = numbers.first
    numbers[1..].each do |num|
      errors.add(:prose, "#{previous} is too far from #{num}.") if num - previous > 1
      errors.add(:prose, "Duplicate entry #{num}") if num == previous
      previous = num
    end
  end
end
