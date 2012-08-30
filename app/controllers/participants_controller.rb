class ParticipantsController < ApplicationController
  respond_to :json
  
  def index
    @participants = Mastermind.participants.inject([]) { |r, (k,v)| r << v.new }
    respond_with @participants
  end
  
  def show
    regex = "(.+)_#{params[:id]}"
    @participant = Mastermind.participants.find { |k, v| regex.match(k) }[-1].new
    respond_with @participant
  end
end