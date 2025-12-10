module ApplicationHelper
  # Available sort options for listings
  SORT_OPTIONS = [
    ["Newest", "newest"],
    ["Price: Low to High", "price_asc"],
    ["Price: High to Low", "price_desc"]
  ].freeze

  def sort_options
    SORT_OPTIONS
  end
end
