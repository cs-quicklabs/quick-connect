class Api::Account::RelationsController < Api::Account::BaseController
  before_action :set_relation, only: %i[ show edit update destroy ]

  def index
    authorize :account
    @relations = Relation.all.order(:name).order(created_at: :desc)
    render json: { success: true, data: @relations, message: "Relations were successfully retrieved." }
  end

  def edit
    authorize :account
    render json: { success: true, data: @relation, message: "" }
  end

  def new
    authorize :account
    @relation = Relation.new
    render json: { success: true, data: @relation, message: "" }
  end

  def create
    authorize :account

    @relation = Relation.new(relation_params)
    respond_to do |format|
      if @relation.save
        format.json { render json: { success: true, data: @relation, message: "Relation was successfully created." } }
      else
        format.json { render json: { success: false, data: @relation, message: @relation.errors } }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @relation.update(relation_params)
        format.json { render json: { success: true, data: @relation, message: "Relation was successfully updated." } }
      else
        format.json { render json: { success: false, data: @relation, message: @relation.errors } }
      end
    end
  end

  def destroy
    authorize :account

    @relation.destroy
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Relation was successfully deleted." } }
    end
  end

  private

  def set_relation
    @relation ||= Relation.find(params[:id])
  end

  def relation_params
    params.require(:api_relation).permit(:name, :account_id)
  end
end
