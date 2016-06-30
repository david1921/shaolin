module Offers
  module Steps
    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def update_step_and_attributes(next_step, attrs = {}, options = {})
        raise "Invalid transition from step '#{step}' to '#{next_step}'" unless (next_step = checked_next_step(next_step))
        assign_attributes attrs
        self.step = next_step
        reset_invalid_attributes_for_later_steps if options[:reset_later_attributes]
        save
      end

      private

      def checked_next_step(next_step)
        value = next_step.to_i
        value if value && value >= first_step && value <= final_step && value <= self.step + 1
      end

      def first_step
        @@first_step ||= Offer::DRAFT_STEPS.min
      end

      def final_step
        @@final_step ||= Offer::DRAFT_STEPS.max
      end

      def invalid_attributes_for_later_steps
        error_attributes = Set.new

        if valid?
          #
          # This procedure won't work if the model is already invalid. It shouldn't
          # be necessary in this case anyway, since the user won't be able to go on
          # to later steps as long as the model can't be saved in this step.
          #
          current_step = self.step
          while (self.step += 1) <= final_step do
            error_attributes += errors.map { |key, val| key if val.present? }.compact unless valid?
            errors.clear
          end
          self.step = current_step
        end

        error_attributes
      end

      def reset_invalid_attributes_for_later_steps
        invalid_attributes_for_later_steps.each do |attr|
          send "#{attr}=", self.class.column_defaults[attr.to_s]
        end
      end
    end
  end
end
