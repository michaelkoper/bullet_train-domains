class Account::DomainsController < Account::ApplicationController
  account_load_and_authorize_resource :domain, through: :team, through_association: :domains

  # GET /account/teams/:team_id/domains
  # GET /account/teams/:team_id/domains.json
  def index
    delegate_json_to_api
  end

  # GET /account/domains/:id
  # GET /account/domains/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/domains/new
  def new
  end

  # GET /account/domains/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/domains
  # POST /account/teams/:team_id/domains.json
  def create
    respond_to do |format|
      if @domain.save
        format.html { redirect_to [ :account, @domain ], notice: I18n.t("domains.notifications.created") }
        format.json { render :show, status: :created, location: [ :account, @domain ] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/domains/:id
  # PATCH/PUT /account/domains/:id.json
  def update
    respond_to do |format|
      if @domain.update(domain_params)
        format.html { redirect_to [ :account, @domain ], notice: I18n.t("domains.notifications.updated") }
        format.json { render :show, status: :ok, location: [ :account, @domain ] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/domains/:id
  # DELETE /account/domains/:id.json
  def destroy
    @domain.destroy
    respond_to do |format|
      format.html { redirect_to [ :account, @team, :domains ], notice: I18n.t("domains.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
