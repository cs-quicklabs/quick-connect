class Account::RelationsController < Account::BaseController
  before_action :set_relation, only: %i[ show edit update destroy ]

  def index
    authorize :account
    @relations = Relation.for_current_account.order(:name).order(created_at: :desc)
    @relation = Relation.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @relation = Relation.new(relation_params)
    respond_to do |format|
      if @relation.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:relations, partial: "account/relations/relation", locals: { relation: @relation }) +
                               turbo_stream.replace(Relation.new, partial: "account/relations/form", locals: { relation: Relation.new, message: "Relation was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Relation.new, partial: "account/relations/form", locals: { relation: @relation }) }
      end
    end
  end

  def update
    authorize :account
    respond_to do |format|
      if @relation.update(relation_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relation, partial: "account/relations/relation", locals: { relation: @relation, messages: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relation, template: "account/relations/edit", locals: { relation: @relation, messages: @relation.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @relation.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@relation) }
    end
  end

  private

  def set_relation
    @relation ||= Relation.find(params[:id])
  end

  def relation_params
    params.require(:relation).permit(:name)
  end
end
