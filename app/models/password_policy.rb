module PasswordPolicy
  
  extend self

  def assign_random_password_to(target)
    target.password = target.password_confirmation = generate_random_password
  end

  def generate_random_password
    ('a'..'z').to_a.shuffle.sample(8).join
  end

end
