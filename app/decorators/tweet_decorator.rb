class TweetDecorator < Draper::Decorator
  delegate_all
  decorates_association :replies

  def date_format(date)
    h.l(date, format: :custom)
  end

end
