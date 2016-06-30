SimpleForm.setup do |config|
  config.wrappers :default, tag: 'fieldset', 
  error_class: 'field_with_errors' do |b|
    b.use :placeholder
    b.use :label
    b.use :input
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    b.optional :tooltip
    b.optional :special_info
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline error_message' }
  end
end


module SimpleForm
  module Components
    module Tooltip
      def tooltip
        if options[:tooltip].present?
          tooltip = options[:tooltip]
          tooltip_content = tooltip.is_a?(String) ? tooltip : translate(:tooltips)
          tooltip_content.html_safe if tooltip_content
          template.content_tag(:a, :class => 'help inline', :"data-tooltip" => tooltip_content) do
          end
        end
      end
    end

    module SpecialInfo
      def special_info
        if options[:special_info].present?
          special_info = options[:special_info]
          special_info_content = special_info.is_a?(String) ? special_info : translate(:special_infos)
          special_info_content.html_safe if special_info_content
          template.content_tag(:span, class: 'special_info') do
            special_info_content
          end
        end
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Tooltip)
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::SpecialInfo)


class DatePickerInput < SimpleForm::Inputs::StringInput 
  def input
    value = object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= I18n.localize(value) if value.present?
    input_html_classes << "date_input"
    super # leave StringInput do the real rendering
  end
end
