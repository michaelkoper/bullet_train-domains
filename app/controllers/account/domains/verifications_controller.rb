class Account::Domains::VerificationsController < Account::ApplicationController
  account_load_and_authorize_resource :domain, through: :team, through_association: :domains

  def create
    @domain_verification = Domains::Verification.new(@domain)
    respond_to do |format|
      if @domain_verification.verify
        format.html { redirect_to [ :account, @domain ], notice: I18n.t("domains.notifications.created") }
      else
        format.html { redirect_to [ :account, @domain ], alert: @domain.errors.full_messages_for(:domain_verification)&.first }
      end
    end
  end
end
