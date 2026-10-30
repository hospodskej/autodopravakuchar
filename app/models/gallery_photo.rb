class GalleryPhoto
  attr_reader :file, :alt

  def self.all
    @all ||= YAML.load_file(Rails.root.join("config/gallery.yml")).map { |attrs| new(**attrs.symbolize_keys) }.freeze
  end

  def self.find(file)
    all.find { |photo| photo.file == file } || raise(ArgumentError, "Unknown gallery photo: #{file}")
  end

  def initialize(file:, alt:)
    @file = file
    @alt = alt
  end

  def path
    "technika/#{file}"
  end

  def thumbnail_path
    "technika/nahled/#{file}"
  end
end
