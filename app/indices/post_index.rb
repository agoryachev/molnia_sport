ThinkingSphinx::Index.define :post, with: :active_record, delta: true do
  indexes title, sortable: true
  indexes subtitle
  indexes content

  has :category_id, type: :integer
  has :published_at
  has :is_published, type: :integer
  where 'is_deleted = 0'
end