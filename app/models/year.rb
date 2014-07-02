# encoding: utf-8
# == Schema Information
#
# Table name: years
#
#  id          :integer          not null, primary key
#  title       :string(255)                            # Название сезона. Например: 2006/2007
#  league_year :integer                                # Год
#  league_id   :integer                                # Связь с лигами
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Year < ActiveRecord::Base
  attr_accessible :title, :league_year, :league_id

  # Relations
  # ================================================================ 
  belongs_to :league
  has_many :leagues_groups, dependent: :destroy
  has_many :leagues_statistics, dependent: :destroy

  # Vaidations
  # ================================================================ 
  validates :league_year, presence: true, format: { with: /(19|20)\d{2}/i, message: 'Год должен быть 4 значным' }

  # Methods
  # ================================================================ 
  def self.get_years_for_select
    all.map{|_| [_.league_year.strftime("%Y"), _.id] }
  end

  def get_json_object
    {
      league_year: league_year,
      league_id: league_id,
      year_id: id,
      year: true
    }.to_json
  end

  def season_title
    self.title.presence ? self.title : self.league_year
  end
end
