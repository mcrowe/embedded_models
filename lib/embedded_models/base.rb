module EmbeddedModels::Base
  extend ActiveSupport::Concern

  included do
    before_update :handle_before_update
  end

  def handle_before_update
    debugger
    @embedded_models.each do |class_name, model|
      debugger
      model.handle_before_update
    end
  end

  module ClassMethods
    def embeds(class_name, options = {})

      embedded_name = class_name
      embedded_class = class_name.to_s.classify.constantize

      define_method embedded_name do
        @embedded_models ||= {}
        @embedded_models[embedded_name] ||= embedded_class.new(self, options)
      end

    end
  end

end

ActiveRecord::Base.send :include, EmbeddedModels::Base