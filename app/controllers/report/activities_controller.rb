class Report::ActivitiesController < Report::BaseController
  ACTIVITY_DATE_COLUMNS = {
    "contacts" => :created_at,
    "events" => :created_at,
    "phone_calls" => :date,
    "conversations" => :date,
    "contact_activities" => :date,
    "contact_events" => :date,
  }.freeze

  def index
    authorize :report

    data = activities
    contributions = contributions(data)
    years = years(data)
    @type = params[:type]
    respond_to do |format|
      format.html
      format.json { render json: { years: years, contributions: contributions } }
    end
  end

  def activities
    start_date = current_user.account.created_at.to_date
    end_date = Date.current
    table_name = params[:type].to_s
    date_column = ACTIVITY_DATE_COLUMNS[table_name]
    return [] if date_column.blank?

    model = table_name.classify.safe_constantize
    return [] unless model

    user_ids = User.where(account_id: current_user.account.id).select(:id)
    relation = model.where(user_id: user_ids)

    relation = if date_column == :created_at
                 relation.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
               else
                 relation.where(date: start_date..end_date)
               end

    grouped_counts = relation.group(Arel.sql("DATE(#{model.table_name}.#{date_column})")).count

    (start_date..end_date).map do |date|
      {
        "date" => date.to_s,
        "count" => grouped_counts[date.to_s] || grouped_counts[date] || 0,
      }
    end
  end

  def years(activities)
    years = activities.map { |row| row["date"].to_date.year }.uniq
    years.map do |year|
      {
        year: year.to_s,
        total: activities.select { |row| row["date"].to_date.year == year }.map { |row| row["count"] }.sum,
        range: {
          start: Date.new(year, 1, 1).to_s,
          end: Date.new(year, 12, 31).to_s,
        },
      }
    end
  end

  def contributions(activities)
    max_count = activities.map { |row| row["count"] }.max

    def intensity(max_count, count)
      boundry = max_count.to_f / 4
      if boundry == 0
        boundry = 1
      end
      intensity = count / boundry.to_f
      if intensity > 4
        intensity = 4
      end
      intensity.ceil
    end

    activities.map do |row|
      {
        date: row["date"],
        count: row["count"],
        color: "#ebedf0",
        intensity: intensity(max_count, row["count"]),
      }
    end
  end
end
