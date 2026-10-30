# Read-only records backed by config/site.yml (exposed as Rails.configuration.x.site).
module SiteContent
  def self.fetch(key)
    Rails.configuration.x.site.fetch(key)
  end

  # Builds records of `klass` from YAML attributes, filling in optional `defaults`.
  def self.build(klass, attrs, **defaults)
    klass.new(**defaults, **attrs.to_h.symbolize_keys)
  end

  # Lookup for any class that defines `all`.
  module Finders
    def find_by!(**conditions)
      all.find { |record| conditions.all? { |attr, value| record.public_send(attr) == value } } ||
        raise(KeyError, "No #{name} matching #{conditions.inspect}")
    end
  end

  # Returns a module that gives a Data class `all` and `find_by!` over the list stored under `key`.
  def self.collection(key, **defaults)
    Module.new do
      include Finders

      define_method(:all) do
        @all ||= SiteContent.fetch(key).map { |attrs| SiteContent.build(self, attrs, **defaults) }.freeze
      end
    end
  end
end
