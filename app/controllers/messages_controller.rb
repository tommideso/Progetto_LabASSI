class MessagesController < ApplicationController
    def create
      @message = current_user.messages.create(body: msg_params[:body], room_id: params[:room_id])
  
      if @message.persisted?
        Rails.logger.info "Messaggio broadcastato nella stanza #{@message.room.id} dall'utente #{@message.user.id}"
        head :no_content
      else
        Rails.logger.error "Messaggio non creato per errori: #{@message.errors.full_messages.join(', ')}"
      end
    end
  
    private
  
    def msg_params
      params.require(:message).permit(:body)
    end
end