class CloudflareService
  class << self
    def create_custom_hostname(hostname)
      hostname_params = {
        hostname:,
        ssl: {
          method: "txt",
          type: "dv"
        }
      }
      api_client.post("zones/#{ENV["CLOUDFLARE_ZONE_ID"]}/custom_hostnames", hostname_params.to_json)
    end

    def custom_hostname(hostname_id)
      api_client.get("zones/#{ENV["CLOUDFLARE_ZONE_ID"]}/custom_hostnames/#{hostname_id}")
    end

    def delete_custom_hostname(hostname_id)
      api_client.delete("zones/#{ENV["CLOUDFLARE_ZONE_ID"]}/custom_hostnames/#{hostname_id}")
    end

    private

    def api_client
      @api_client ||= Faraday.new(
        url: base_url,
        headers: default_headers
      ) do |builder|
        builder.request :authorization, "Bearer", -> { ENV["CLOUDFLARE_API_TOKEN"] }
        builder.response :json
        builder.use Oauth::RequestLogger if Rails.env.development?
      end
    end

    def default_headers
      {
        "Content-Type": "application/json"
      }
    end

    def base_url
      "https://api.cloudflare.com/client/v4"
    end
  end
end
