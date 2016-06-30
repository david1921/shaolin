class LibraryImage < ActiveRecord::Base
  acts_as_list

  attr_accessible :photo, :position

  has_attached_file :photo, :styles => {
    :normal => { :geometry => "600x371#", :format => :jpg },
    :review => { :geometry => "300x186#", :format => :jpg },
    :gallery => { :geometry => "150x93#", :format => :jpg }
  }
  validates_attachment_presence :photo

  def delete!
    update_attribute :deleted_at, Time.zone.now unless deleted_at
  end

  def self.all_active
    where(:deleted_at => nil).order(:position)
  end
end
