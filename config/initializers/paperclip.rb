Paperclip::Attachment.default_options[:storage] = "s3"
Paperclip::Attachment.default_options[:s3_credentials] = "#{Rails.root}/config/paperclip_s3.yml"
Paperclip::Attachment.default_options[:bucket] = "merchant-portal-public"
Paperclip::Attachment.default_options[:path] = "/:rails_env/:class/:attachment/:id-:timestamp/:style.:extension"
Paperclip::Attachment.default_options[:s3_headers] = { "Cache-Control" => "max-age=31556926", "Expires" => 1.year.from_now.httpdate }
Paperclip::Attachment.default_options[:s3_protocol] = ""
Paperclip::Attachment.default_options[:url] = ":s3_alias_url"
Paperclip::Attachment.default_options[:s3_host_alias] = "d3tv4tw4jg4ucp.cloudfront.net"
Paperclip::Attachment.default_options[:default_style] = :normal
Paperclip::Attachment.default_options[:whiny_thumbnails] = true
Paperclip::Attachment.default_options[:convert_options] = { :all => '-strip' }
