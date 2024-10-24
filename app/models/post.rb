class Post < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, :body, presence: true

  pg_search_scope :by_title_or_body, against: [ :title, :body ]
end
