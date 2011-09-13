module I18n
  module Alchemy
    # If you wanna override the Assign Attributes from ActiveRecord you can include 
    # this module. 
    #
    # Maybe rename this methods to #alchemy_assign_attributes= is a better idea
    #
    module Attributes
      # Allows you to set all the attributes at once by passing in a hash with keys
      # matching the attribute names (which again matches the column names).
      #
      def attributes=(new_attributes)
        return unless new_attributes.is_a?(Hash)

        self.assign_attributes(new_attributes)
      end
      
      # Allows you to set all the attributes for a particular mass-assignment
      # security role by passing in a hash of attributes with keys matching
      # the attribute names (which again matches the column names) and the role
      # name using the :as option.
      #
      # To bypass mass-assignment security you can use the :without_protection => true
      # option.
      #      
      # TODO: Handle multi parameters attributes
      #
      def assign_attributes(attributes, options={})
        attributes = sanitize_for_mass_assignment(attributes, self.send(:mass_assignment_role)) unless options[:without_protection]
        attributes.each do |key, value|
          if self.respond_to?("#{key}=")
            self.localized.send("#{key}=", value) # Just all of this, for this line! Do you have a better idea? I'm tired :\
          else
            raise(::ActiveRecord::UnknownAttributeError, "unknown attribute: #{key}")
          end
        end
      end
    end
  end
end