module EmbeddedModels::Base
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def embeds(class_name, options = {})

      embedded_name = class_name
      embedded_class = class_name.to_s.classify.constantize


      @@_embedded_models = {}

      define_method embedded_name do
        @@_embedded_models[embedded_name] ||= embedded_class.new(self, options)
      end

    end
  end

end

ActiveRecord::Base.send :include, EmbeddedModels::Base