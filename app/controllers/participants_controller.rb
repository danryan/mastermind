class ProvidersController < ApplicationController
  respond_to :json
  
  def index
    @providers = Mastermind.providers.inject([]) { |r, (k,v)| r << v.new }
    respond_with @providers
  end
  
  def show
    regex = "(.+)_#{params[:id]}"
    @provider = Mastermind.providers.find { |k, v| regex.match(k) }[-1].new
    respond_with @provider
  end
end