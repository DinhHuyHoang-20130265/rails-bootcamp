module OwnershipAuthorization
  extend ActiveSupport::Concern

  private

  def authorize_owner!(record)
    owner_id =
      if record.user_id.present?
        record.user_id
      elsif record.model.present? && record.model.user_id.present?
        record.model.user_id
      end

    if owner_id == current_user&.id
      redirect_to tweets_path, alert: "Not authorized."
    end
  end
end
