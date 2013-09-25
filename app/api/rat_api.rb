require 'grape'

require File.dirname(__FILE__) + "/../../config/environment"

require 'handler/example'

# curl -k -H "Content-Type:text/json" http://localhost:9292/test/time

module Rat
  class API < Grape::API
    version 'v1', using: :header, vendor: 'rat'

    formatter :xml, lambda { |object, _| Converter.new.to_xml(object) }
    formatter :json, lambda { |object, _| Converter.new.to_json(object) }

    #helpers do
    #  def current_user
    #    @current_user ||= User.authorize!(env)
    #  end
    #
    #  def authenticate!
    #    error!('401 Unauthorized', 401) unless current_user
    #  end
    #end

    resource :api do

      desc "test"
      get :test do
        hash = {:a => 'b', :c => 'd'}

        hash
      end

      desc "Calls example"
      get :example do
        handler = Handler::Example.new

        handler.example
      end
      #end
    end

    #resource :statuses do
    #
    #  desc "Return a public timeline."
    #  get :public_timeline do
    #    Status.limit(20)
    #  end
    #
    #  desc "Return a personal timeline."
    #  get :home_timeline do
    #    authenticate!
    #    current_user.statuses.limit(20)
    #  end
    #
    #  desc "Return a status."
    #  params do
    #    requires :id, type: Integer, desc: "Status id."
    #  end
    #  route_param :id do
    #    get do
    #      Status.find(params[:id])
    #    end
    #  end
    #
    #  desc "Create a status."
    #  params do
    #    requires :status, type: String, desc: "Your status."
    #  end
    #  post do
    #    authenticate!
    #    Status.create!({
    #                     user: current_user,
    #                     text: params[:status]
    #                   })
    #  end
    #
    #  desc "Update a status."
    #  params do
    #    requires :id, type: String, desc: "Status ID."
    #    requires :status, type: String, desc: "Your status."
    #  end
    #  put ':id' do
    #    authenticate!
    #    current_user.statuses.find(params[:id]).update({
    #                                                     user: current_user,
    #                                                     text: params[:status]
    #                                                   })
    #  end
    #
    #  desc "Delete a status."
    #  params do
    #    requires :id, type: String, desc: "Status ID."
    #  end
    #  delete ':id' do
    #    authenticate!
    #    current_user.statuses.find(params[:id]).destroy
    #  end
    #
    #end
  end
end
