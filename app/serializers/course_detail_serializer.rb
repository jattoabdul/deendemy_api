class CourseDetailSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :type, :status, :copy_text, :seo, :language, :level, :configs, :created_at, :updated_at, :rating, :curriculum, :categories

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
  has_many :chapters, serializer: ChapterSerializer

  def rating
    object.ratings.map(&:rating).sum(0.0) / object.ratings.size
  end

  def curriculum
    curriculum = []
    object.chapters.each do |chapter|
      new_chapter = chapter.attributes.merge(
          ActiveModelSerializers::SerializableResource.new(chapter.lessons, {serializer_each: LessonSerializer}).as_json
      )
      curriculum.push(new_chapter)
    end

    curriculum
  end

  def categories
    object.categories.as_json(only: %i(_id name))
  end
end
