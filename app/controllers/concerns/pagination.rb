module Pagination
  extend ActiveSupport::Concern

  included do
    helper_method :current_page, :per_page
  end

  def current_page
    value = params[:page].to_i
    value.positive? ? value : 1
  end

  def per_page
    (defined?(@per_page) && @per_page.to_i.positive?) ? @per_page.to_i : default_per_page
  end

  def default_per_page
    10
  end

  def paginate(scope)
    collection = scope.for_page(current_page, per_page)
    has_more = Tweet.has_more_for?(scope, page: current_page, per_page: per_page)
    [ collection, has_more ]
  end
end
