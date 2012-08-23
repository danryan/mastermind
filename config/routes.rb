Mastermind::Application.routes.draw do
  get "definitions/index"

  get "definitions/show"

  get "definitions/new"

  get "definitions/create"

  get "definitions/edit"

  get "definitions/update"

  get "definitions/destroy"

  match '/_ruote' => RuoteKit::Application
  match '/_ruote/*path' => RuoteKit::Application
end
