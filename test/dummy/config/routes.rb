Rails.application.routes.draw do
  mount BulletTrain::Domains::Engine => "/bullet_train-domains"
end
