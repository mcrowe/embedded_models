module EmbeddedModels::Embedded
  extend ActiveSupport::Concern

  included do
    @before_update_callbacks = []
  end

  def initialize(composite, options)
    @composite = composite
    @options = options
    @prefix = self.class.name.underscore

    attributes.each do |column, _|

      # [attribute]
      # Returns the value of the given attribute.
      #
      self.class.send :define_method, column do
        attributes[column]
      end

      # [attribute]=(value)
      # Sets the value of the given attribute.
      #
      self.class.send :define_method, "#{column}=" do |value|
        attributes[column] = value
      end

      # [attribute]_changed?
      # Returns true if the attribute has changed, false otherwise.
      #
      self.class.send :define_method, "#{column}_changed?" do
        attribute_changed?(column)
      end

    end
  end

  def attributes
    @attributes ||= build_attributes
  end

  def update_attributes(new_attributes)
    if set_attributes(new_attributes)
      save
    end
  end

  def update_attributes!(new_attributes)
    if set_attributes(new_attributes)
      save!
    end
  end

  def save
    @composite.update_attributes(full_attributes)
  end

  def save!
    @composite.update_attributes!(full_attributes)
  end

  def handle_before_update
    if attributes.any? { |k, _| attribute_changed?(k) }
      self.class.before_update_callbacks.each do |callback|
        send(callback)
      end
    end
  end

  private

    def attribute_changed?(attribute)
      @composite.attributes["#{full_column(attribute)}"] != attributes[attribute]
    end

    def set_attributes(new_attributes)
      return false unless new_attributes.all? { |k, _| attribute?(k) }
      @attributes = new_attributes
    end

    def full_column(column)
      "#{@prefix}_#{column}"
    end

    def full_attributes
      Hash[attributes.map { |k, v| [full_column(k), v] }]
    end

    def attribute?(attribute)
      attributes.keys.include?(attribute.to_s) || attributes.keys.include?(attribute.to_sym)
    end

    # Returns the subset of the composite's attributes who's keys start with @prefix.
    # Strip @prefix off of the keys.
    def build_attributes
      embedded_attributes = @composite.attributes.select { |k, v| k.starts_with?(@prefix) }
      Hash[embedded_attributes.map { |k, v| [k.slice((@prefix.size + 1)..-1), v] }].with_indifferent_access
    end

  module ClassMethods

    def before_update(method)
      @before_update_callbacks << method
    end

    def before_update_callbacks
      @before_update_callbacks
    end

  end

end