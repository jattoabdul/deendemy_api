class ChapterSerializer < ActiveModel::Serializer
  attributes :id, :reference, :title, :objective, :position

  belongs_to :course
  has_many :lessons
end
