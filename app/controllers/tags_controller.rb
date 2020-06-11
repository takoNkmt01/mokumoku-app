class TagsController < ApplicationController
  def show
    tag = Tag.find(params[:id])
    @search_param = '#' + tag.name
    @events = tag.events.recent.page(params[:page]).per(5)
    @tags = Tag.all
    render template: 'events/index'
  end
end
