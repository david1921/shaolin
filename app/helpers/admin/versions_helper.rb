module Admin
  module VersionsHelper

    class Entry

      attr_reader :time, :username, :description

      def initialize(time, username, description)
        @time 				= time
        @username 		= username
        @description 	= description
      end

      def <=>(other)
        other.time <=> time
      end

    end

    def render_entry(entry)
      content = []
      content.push( entry.description || "" )
      content.push( "at #{entry.time.strftime("%H:%M")}" )
      content.push( "by #{entry.username}" ) if entry.username.present?
      content.join(" ")
    end

    def description_from_attribute_and_values(attribute, values)
      changed_from = values.first
      changed_to   = values.last
      if changed_from.blank?
        "#{attribute.humanize} was changed to '#{changed_to}'"
      else
        "#{attribute.humanize} was changed from '#{changed_from}' to '#{changed_to}'"
      end
    end

    def extract_username_from_version(version)
      return "" unless version
      version.user ? version.user.login : version.user_name
    end

  end
end