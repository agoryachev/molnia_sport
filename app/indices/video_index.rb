ThinkingSphinx::Index.define :video, with: :active_record do
  indexes title, sortable: true

  has :category_id, type: :integer
  has :published_at
  has :is_published, type: :integer
  where 'is_deleted = 0'
end