class CourseSerializer < ActiveModel::Serializer
  attributes :id, :reference, :title, :subtitle, :categories, :curriculum, :type, :price, :status, :copy_text, :seo, :language, :level, :configs, :created_at, :updated_at

  belongs_to :tutor, serializer: UserSerializer
  belongs_to :label, serializer: MediaSerializer
  # belongs_to :introduction, serializer: LessonSerializer
  # has_and_belongs_to_many :categories
end