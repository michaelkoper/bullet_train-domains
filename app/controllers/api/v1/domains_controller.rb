# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::DomainsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :domain, through: :team, through_association: :domains

    # GET /api/v1/teams/:team_id/domains
    def index
    end

    # GET /api/v1/domains/:id
    def show
    end

    # POST /api/v1/teams/:team_id/domains
    def create
      if @domain.save
        render :show, status: :created, location: [ :api, :v1, @domain ]
      else
        render json: @domain.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/domains/:id
    def update
      if @domain.update(domain_params)
        render :show
      else
        render json: @domain.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/domains/:id
    def destroy
      @domain.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def domain_params
        strong_params = params.require(:domain).permit(
          *permitted_fields,
          :address,
          :status,
          :external_hostname_id,
          :txt_verification_name,
          :txt_verification_value,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::DomainsController
  end
end
