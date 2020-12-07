class TopicLike < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  include PgSearch::Model
  multisearchable against: [:title, :content]
end
