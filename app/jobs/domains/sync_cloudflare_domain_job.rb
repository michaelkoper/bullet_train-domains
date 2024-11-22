class Domains::SyncCloudflareDomainJob < ApplicationJob
  queue_as :default

  def perform(domain)
    domain.sync_cloudflare_domain!
  end
end
