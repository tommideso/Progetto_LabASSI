class MessagesController < ApplicationController
    def create
        # creiamo un nuovo messaggio
        @message = current_user.messages.create(body: msg_params[:body], room_id: params[:room_id])
    end


    private
    
    def msg_params
        params.require(:message).permit(:body)
    end
end