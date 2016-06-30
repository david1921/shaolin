require 'active_support/gzip'

class KeyInformationAgreement < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  attr_accessible :html, :signature_params, :electronically_signed

  has_attached_file :signature, {
    bucket: "merchant-portal-secure",
    path: "/:rails_env/:class/:attachment/:id-:hash/:style.:extension",
    hash_secret: "JqZrjeDdPck1Pmn",
    s3_permissions: :private,
    url: ":s3_path_url",
    styles: { normal: ["100%", :png] },
  }
  validates_attachment :signature, attachment_presence: true, unless: "self.electronically_signed?"
  validates :electronically_signed, presence: true, unless: "self.signature.present?"
  validates :html, :presence => true

  def signature_params=(value)
    io = StringIO.new(value[:data])
    io.define_singleton_method(:original_filename) { value[:name] }
    io.define_singleton_method(:content_type) { value[:type] }
    self.signature = io
  end

  def html=(value)
    write_attribute :gzipped_html, ::ActiveSupport::Gzip.compress(value)
  end

  def html
    gzipped_html && ::ActiveSupport::Gzip.decompress(read_attribute(:gzipped_html))
  end

  def signature_file
    Paperclip.io_adapters.for(signature.styles[:normal]).path
  end
end

