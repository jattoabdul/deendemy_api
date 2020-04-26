class CourseSerializer < ActiveModel::Serializer
  attributes :id, :reference, :title, :subtitle, :tutor_id, :categories, :label, :introduction, :curriculum, :type, :price, :status, :copy_text, :seo, :language, :level, :configs
end
