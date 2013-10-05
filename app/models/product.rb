class Product < ActiveRecord::Base
  has_and_belongs_to_many :families
  has_and_belongs_to_many :categories
  belongs_to :family
  include BeautifulScaffoldModule      

  before_save :fulltext_field_processing

  def fulltext_field_processing
    # You can preparse with own things here
    generate_fulltext_field([])
  end
  scope :sorting, lambda{ |options|
    attribute = options[:attribute]
    direction = options[:sorting]

    attribute ||= "id"
    direction ||= "DESC"

    order("#{attribute} #{direction}")
  }
    # You can OVERRIDE this method used in model form and search form (in belongs_to relation)
  def caption
    (self["name"] || self["label"] || self["description"] || "##{id}")
  end
  attr_accessible :family_ids, :categories_ids, :family_id, :description, :name, :price, :tva, :visible
end
