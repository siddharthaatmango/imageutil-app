class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update]
  before_action :get_projects, only: [:index]

  # GET /projects
  # GET /projects.json
  def index
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.name = ""
    @project.uuid = SecureRandom.hex(10)
    @project.created_at = Time.now
  end

  # GET /projects/1
  def show
    render :edit
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id

    respond_to do |format|
      if @project.save
        format.html { render :edit, notice: 'Project was successfully created.' }
        format.json { render :edit, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { render :edit, notice: 'Project was successfully updated.' }
        format.json { render :edit, status: :ok, location: @project }
      else
        format.html { render :edit }
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
