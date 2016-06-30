module RegistrationsHelper

  def registration_path_for_form(registration)
    registration.try(:new_record?) ? registrations_path : registration_path(registration.uuid)
  end

end
