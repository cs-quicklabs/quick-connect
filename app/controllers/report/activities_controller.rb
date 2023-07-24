class Report::ActivitiesController < Report::BaseController
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
    start_date = current_user.account.created_at.to_date.to_s
    end_date = Date.today.to_s
    account = current_user.account.id
    table_name = params[:type]
    if table_name == "contacts" or table_name == "events"
      sql = "SELECT s.tag::date AS date , count(t.id) AS count FROM  (SELECT generate_series(timestamp '#{start_date}', timestamp '#{end_date}', interval  '1 day') AS tag ) s  LEFT   JOIN #{table_name} t ON t.created_at::date = s.tag AND t.user_id IN ( Select id from users where account_id = #{account}) GROUP  BY 1 ORDER  BY 1;"
    else
      sql = "SELECT s.tag::date AS date , count(t.id) AS count FROM  (SELECT generate_series(timestamp '#{start_date}', timestamp '#{end_date}', interval  '1 day') AS tag ) s  LEFT   JOIN #{table_name} t ON t.date::date = s.tag AND t.user_id IN ( Select id from users where account_id = #{account}) GROUP  BY 1 ORDER  BY 1;"
    end
    result = ActiveRecord::Base.connection.execute(sql)
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
