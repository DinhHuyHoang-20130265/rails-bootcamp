module OwnershipAuthorization
  extend ActiveSupport::Concern

  private

  def authorize_owner!(record)
    owner_id = if record.respond_to?(:user_id)
                 record.user_id
    elsif record.respond_to?(:model) && record.model.respond_to?(:user_id)
                 record.model.user_id
    end

    redirect_to tweets_path, alert: "Not authorized." unless owner_id == current_user&.id
  end
end


