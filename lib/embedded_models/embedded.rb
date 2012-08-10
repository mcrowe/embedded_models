module EmbeddedModels::Embedded

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

private

  def set_attributes(new_attributes)
    return false unless new_attributes.all? { |k, _| attribute?(k) }
    @attributes = new_attributes
  end

  def full_attributes
    Hash[attributes.map { |k, v| ["#{@prefix}_#{k}", v] }]
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

end