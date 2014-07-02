class AuthorsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view
  
  def initialize(view, authors_array, klass)
    @klass, @view, @authors_array = klass.underscore, view, authors_array
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Author.count,
      iTotalDisplayRecords: authors.total_entries,
      aaData: data
    }
  end

private

  def data
    authors.map do |author|     
      [
        "<input id='#{@klass}_author_ids_' class= 'data-authors' name='#{@klass}[author_ids][]' type='checkbox' value='#{author.id}' #{"checked" if @authors_array.include?(author.id)}>".html_safe ,
        author.id,
        author.name
      ]
    end
  end

  def authors
    @authors ||= fetch_authors
  end

  def fetch_authors    
    if params[:sSearch].present? && params[:sSearch].length >= 3     
      authors = Author.search name: params[:sSearch]#, without: {is_deleted: 1}, page: page, per_page: per_page, order: "#{sort_column} #{sort_direction}" 
    else
      authors = @authors_array.blank? ? Author : Author.where("id NOT IN (?)", @authors_array)             
    end
    authors = authors.order("#{sort_column} #{sort_direction}").page(page).per_page(per_page)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id id name]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end




end