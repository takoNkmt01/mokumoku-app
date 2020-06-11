class TagsController < ApplicationController
  def show
    tag = Tag.find(params[:id])
    @q = tag.events.order(created_at: :desc).ransack(params[:q])
    @events = @q.result(distinct: true).page(params[:page]).per(5)
    @tags = Tag.all
    render template: 'events/index'
  end
end
