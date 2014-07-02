ThinkingSphinx::Index.define :team, with: :active_record do
  indexes title, sortable: true
  indexes content

  has :category_id, type: :integer
  where 'is_deleted = 0'
end