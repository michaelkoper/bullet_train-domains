require 'bullet_train/domains/version'
require 'bullet_train/domains/engine'

module BulletTrain
  module Domains
    module Teams
      module Base
        extend ActiveSupport::Concern

        included do
        end
      end
    end
  end
end

ActiveSupport.on_load(:bullet_train_teams_base) { include BulletTrain::Domains::Teams::Base }
ActiveSupport.on_load(:bullet_train_account_controllers_base) do
  # include Domains::ControllerSupport
end
