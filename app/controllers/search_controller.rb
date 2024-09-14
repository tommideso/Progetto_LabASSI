class SearchController < ApplicationController
  def index
    @q = Menu.ransack(params[:q])
    @menus = @q.result(distinct: true).where(disattivato: false)

    puts "PARAMS: #{params}"
    # filtri personalizzati
    if params[:numero_persone].present?
      numero_persone = params[:numero_persone]
      @menus = @menus.where("min_persone <= ? AND max_persone >= ?", numero_persone, numero_persone)
    end

    if params[:allergeni].present?
      allergeni_query = params[:allergeni].map { |allergene| "allergeni ->> '#{allergene}' = 'false'" }.join(" AND ")
      @menus = @menus.where(allergeni_query)
    end

    if params[:preferenze].present?
      preferenze_query = params[:preferenze].map { |preferenza| "preferenze_alimentari ->> '#{preferenza}' = 'true'" }.join(" AND ")
      @menus = @menus.where(preferenze_query)
    end

    if params[:search_date].present?
      @menus = @menus.disponibili_per_data(params[:search_date])
    end
  end
end
