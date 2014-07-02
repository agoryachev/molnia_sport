ThinkingSphinx::Index.define :league, with: :active_record do
  indexes title, sortable: true
  indexes content

  has :country_id, type: :integer
  where 'is_deleted = 0'
end