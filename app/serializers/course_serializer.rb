class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :type, :status, :copy_text, :seo, :language, :level, :configs, :created_at, :updated_at

  attribute :price do
    object.price.cents
  end
  attribute :formated_price do
    object.price.format
  end
  attribute :currency do
    object.currency.iso_code
  end

  belongs_to :tutor, serializer: UserSerializer
  belongs_to :label, serializer: MediaSerializer
  belongs_to :introduction, serializer: LessonSerializer
  # has_and_belongs_to_many :categories
  # has_many :chapters

  # def curriculum
  #   return curriculum details with chapters and lessons that belong to each chapters.
  # end
end
