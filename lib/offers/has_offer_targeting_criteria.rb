module Offers
  module HasOfferTargetingCriteria
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def has_offer_targeting_criteria(attr_name, options = {})
        options.assert_valid_keys(:allowed_values, :criterion_type)
        raise ArgumentError, ":allowed_values must be non-blank" unless options[:allowed_values].present?
        raise ArgumentError, ":criterion_type must be non-blank" unless options[:criterion_type].present?

        allowed_values = options[:allowed_values]
        criterion_type = options[:criterion_type]

        validate :"#{attr_name}_in_allowed_values"
        after_save :"update_#{attr_name}_if_changed"

        define_method("#{attr_name}_in_allowed_values") do
          break unless send("#{attr_name}_changed?")
          value = send(attr_name)
          break unless value.present?
          invalid_values = value.select { |v| !allowed_values.include?(v) }
          invalid_values.each do |r|
            errors.add(attr_name, "'#{r}' is not a valid #{attr_name.to_s.singularize.humanize.downcase}")
          end
        end

        define_method("update_#{attr_name}_if_changed") do
          if send("#{attr_name}_changed?")
            offer_targeting_criteria.send(criterion_type).each(&:destroy)
            instance_variable_get("@#{attr_name}").each do |r|
              offer_targeting_criteria.create!(criterion_type: criterion_type, value: r)
            end
          end
          true
        end

        define_method("#{attr_name}=") do |target_ranges|
          target_ranges = [] if target_ranges.blank?
          instance_variable_set("@#{attr_name}_changed", true)
          instance_variable_set("@#{attr_name}", target_ranges)
        end

        define_method(attr_name) do
          if send("#{attr_name}_changed?")
            instance_variable_get("@#{attr_name}") 
          else
            offer_targeting_criteria.send(criterion_type).map(&:value)    
          end
        end

        define_method("#{attr_name}_changed?") do
          instance_variable_get("@#{attr_name}_changed")
        end

        OfferTargetingCriterion.class_eval do
          validates :value, inclusion: { in: allowed_values }, if: :"#{criterion_type}?"

          scope :"#{criterion_type}", conditions: { criterion_type: criterion_type }
          my_criterion_type = criterion_type

          define_method("#{criterion_type}?") do
            self.criterion_type == my_criterion_type
          end
        end
      end
    end
  end
end
