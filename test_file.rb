class ProjectsController < ApplicationController
  def index
    if params[:status]
      status = params[:status]
      # @projects = Project.joins(:drawings).select("projects.*, drawings.project_id, count('a')").merge(Drawing.where(status: status)).group(:name).order("count('a') DESC")
      @projects = Project.joins(:drawings).select("projects.*, drawings.project_id, count('a')").merge( Drawing.where(status: status)).group(:id, '"drawings"."project_id"').order("count('a') DESC")
    else
      @projects = Project.order(:number).all
    end
  end

  def show
    @project = Project.find(params[:id])
    @drawing = Drawing.new
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new params[:project]
    if @project.save
      redirect_to projects_path
    else
      flash[:error] = "Footage is a required field"
      redirect_to new_project_path
    end
  end

  def ready
    @projects = Project.joins(:drawings).select("projects.*, drawings.project_id, count('a')").merge( Drawing.where(status: "ready")).group(:id, '"drawings"."project_id"').order("count('a') DESC")
  end

  def by_status
    @project = Project.find(params[:id])
    @drawings = Drawing.by_status(@project)
  end
end
