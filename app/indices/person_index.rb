ThinkingSphinx::Index.define :person, with: :active_record do
  indexes name_first, sortable: true
  indexes name_last, sortable: true
  indexes name_v
  indexes content

  where 'is_deleted = 0'
end