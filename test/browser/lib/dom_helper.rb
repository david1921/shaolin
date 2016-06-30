module BrowserTests
  module DomHelper
    def select_value(value, options={})
      option_selector = "option[value='#{value}']"
      if options.has_key? :from
        path = XPath::HTML.select options[:from]
        select = find(:xpath, path)
        option = select.find option_selector
      else
        option = find option_selector
      end
      option.select_option
    end

    def fill_in_for(prefix, attributes)
      attributes.each do |key, value| 
        fill_in "#{prefix}_#{key}", with: value
      end
    end

    def fill_in_for_factory(factory, attributes)
      model = build factory
      fill_in_for_model model, attributes
      model
    end

    def fill_in_for_model(model, attributes)
      prefix = ActiveSupport::Inflector.underscore model.class
      attributes.each do |attribute|
        fill_in "#{prefix}_#{attribute}", with: model.send(attribute).to_s
      end
    end
    
    def select_values_for_model(model, attributes)
      prefix = ActiveSupport::Inflector.underscore model.class
      attributes.each do |attribute|
        select_value model.send(attribute).to_s, from: "#{prefix}_#{attribute}"
      end
    end
  end
end