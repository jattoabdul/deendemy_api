class ChapterSerializer < ActiveModel::Serializer
  attributes :id, :reference, :title, :objective, :is_last

  belongs_to :course
end
