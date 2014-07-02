class Backend::CountriesController < Backend::BackendController
  before_filter :set_country, only: [:edit, :update, :destroy]

  # GET /backend/countries
  def index
    if params[:search].present?
      @countries = Country.search(params[:search])
      return @countries
    else
      @countries = Country
                  .includes(:categories)
                  .order(:title)
                  .paginate(page: params[:page], limit: Setting.records_per_page)
    end
  end

  # GET /backend/countries/new
  def new
    @country = Country.new
  end

  # POST backend/categories
  def create
    @country = Country.new(params[:country])
    if @country.save
      create_successful
    else
      create_failed
    end
  end

  # GET /backend/countries/:id/edit
  def edit
    @categories = Category::categories_for_select
  end

  # PUT /backend/countries/:id
  def update
    if @country.update_attributes(params[:country])
      update_successful
    else
      update_failed
    end
  end

  # POST /backend/countries/get_countries_for_ajax(.:format)
  def get_countries_for_ajax
    countries = Country
                    .joins('inner JOIN categories_countries AS cc')
                    .where("countries.id = cc.country_id AND cc.category_id = ?", params[:category_id])

    render json: countries, layout: false
  end

  # DELETE /backend/countries/:id(.:format)
  def destroy
    @country.destroy
    destroy_successful
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end

end
