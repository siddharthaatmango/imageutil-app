class FoldersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project
    before_action :set_folder, only: [:index, :update, :tokenize]

    def index
      if !@folder
        @root = Folder.root_node(@projects, current_user.is_support?)
      else
        @root = Folder.get_node(@project.id, @folder.id, current_user.is_support?)
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

    def tokenize
      render json: {upload_token: @folder.tokenize, upload_host: @folder.upload_host}, status: :ok
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project_id = params[:project_id]
        if @project_id=='ALL'
          @projects = current_user.is_support? ? Project.all : Project.where(user_id: current_user.id).to_a
        else
          @project = current_user.is_support? ?  Project.where(id: @project_id).first : Project.where(user_id: current_user.id, id: @project_id).first
          @projects = [@project]
        end
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_folder
        @folder_id = params[:folder_id] ? params[:folder_id] : params[:id]
        unless @folder_id=="#"
          @folder = current_user.is_support? ? Folder.where(id: @folder_id).first  : Folder.where(user_id: current_user.id, id: @folder_id).first

          params[:project_id] = @project_id = @folder.project_id
          @project = current_user.is_support? ?  Project.where(id: @project_id).first : Project.where(user_id: current_user.id, id: @project_id).first unless @project
        end
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def folder_params
        params.require(:folder).permit(:folder_id, :name)
      end
end
