class ReplyDecorator < Draper::Decorator
  delegate_all

  def date_format(date)
    h.l(date, format: :custom)
  end

end
