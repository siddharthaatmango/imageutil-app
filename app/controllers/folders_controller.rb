class FoldersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project
    before_action :set_folder, only: [:index, :update]

    def index
      if params[:id]=="#" || !@folder
        @root = Folder.root_node([@project])
      else
        @root = Folder.get_node(@project.id, @folder.id)
      end
      render json: @root
    end

    def create
      folder = Folder.new(folder_params)
      folder.user_id = current_user.id
      folder.project_id = @project.id
      folder.folder_id = @folder.id if @folder
      if folder.save
        render json: folder, status: :created
      else
        render json: folder.errors, status: :unprocessable_entity
      end
    end


    def update
      if @folder.update(folder_params)
        render json: @folder, status: :ok
      else
        render json: @folder.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project = Project.where(user_id: current_user.id, id: params[:project_id]).first
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_folder
        @folder = Folder.where(user_id: current_user.id, project_id: params[:project_id], id: params[:id]).first unless params[:id]=="#"
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def folder_params
        params.require(:folder).permit(:folder_id, :name)
      end
end
