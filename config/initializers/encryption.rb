case Rails.env
when "production"
  path = File.expand_path("config/attr_encrypted/key.txt", Rails.root)
  Encryption::AttrEncrypted.default_options[:key] = File::read(path).chomp
else
  Encryption::AttrEncrypted.default_options[:key] = "opensesame"
end
