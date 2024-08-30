class SearchController < ApplicationController
  def index
    @q=Menu.ransack(params[:q])
    @menus = @q.result(distinct: true)
  end
end
