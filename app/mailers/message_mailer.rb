class MessageMailer < ApplicationMailer
    default from: 'support@imageutil.io'
    layout 'mailer'

    def new_message(message)
        @support_user = User.where(is_support: true).first
        @message = message
        @by_user = message.user
        @to_user = @support_user
        mail(to: @to_user.email, subject: "Support ticket added by #{@by_user.name ? @by_user.name : @by_user.email}")
    end

    def new_reply(message, reply)
        @support_user = User.where(is_support: true).first
        @message = message
        @by_user = reply.user
        @to_user = message.user == reply.user ? @support_user : message.user
        mail(to: @to_user.email, subject: "Reply added to support ticket by #{@by_user.name ? @by_user.name : @by_user.email}")
    end
end
