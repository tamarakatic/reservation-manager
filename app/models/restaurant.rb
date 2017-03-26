class Restaurant < ApplicationRecord
  belongs_to :manager
  has_many :foods, dependent: :destroy
  has_many :drinks, dependent: :destroy
  has_many :seats, dependent: :destroy
  has_many :restaurant_providers
  has_many :providers, :through => :restaurant_providers
  has_many :orders
  has_many :restaurant_reviews
  has_many :reviews, :through => :restaurant_reviews
  has_many :reservations
  has_many :tables, :through => :seats, :source => :number_of_seats

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  validates :title, :uniqueness => true,
                    :length => { :in => 2..30 },
                    :presence => true,
                    :allow_blank => false

  validates :description, :length => { :maximum => 300 },
                          :presence => true,
                          :allow_blank => false

  validates :category, :length => { :maximum => 30 },
                       :allow_blank => false

  def self.sort_options
    [
      ["Name (A-Z)", "title_asc"],
      ["Name (Z-A)", "title_desc"],
      ["Category (A-Z)", "category_asc"],
      ["Category (Z-A)", "category_desc"]
    ]
  end

  filterrific :default_filter_params => { :sorted_by => "title_asc" },
              :available_filters => %w[
                sorted_by
                search_query
              ]

  scope :search_query, lambda { |query|
    return nil if query.blank?

    where("title ILIKE ? or category ILIKE ?", "%#{query}%", "%#{query}%")
  }

  scope :sorted_by, lambda { |option|
    direction = (option =~ /desc$/) ? "desc" : "asc"

    case option.to_s
    when /^title/
      order("LOWER(restaurants.title) #{direction}")
    when /^category/
      order("LOWER(restaurants.category) #{direction}")
    end
  }

end
