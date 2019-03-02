class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:edit, :update]
  before_action :get_projects

  # GET /projects
  # GET /projects.json
  def index
    @project = @projects.first
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.name = ""
    @project.uuid = SecureRandom.hex(10)
    @project.created_at = Time.now
    @projects.push(@project)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /projects/1/edit
  def edit

    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_url, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { redirect_to projects_url, error: @project.errors.first}
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_url, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { redirect_to projects_url, error: @project.errors.first }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.is_support? ? Project.where(id: params[:id]).first : Project.where(user_id: current_user.id, id: params[:id]).first
    end

    def get_projects
      @projects = current_user.is_support? ? Project.all : Project.where(user_id: current_user.id).to_a
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :uuid, :fqdn, :is_active, :protocol)
    end
end
