class StaticPagesController < ApplicationController
  def home
    @post  = current_user.posts.build
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5 )
    @common_feed_items= Post.order('created_at DESC').limit(50).paginate(page: params[:page], per_page: 5 )
  end

  def help
  end

  def about
  end

  def contact
  end

end
