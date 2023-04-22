class Report::ActivitiesController < Report::BaseController
  def index
    authorize :report

    contributions = contributions(activities)
    years = years(activities)
    respond_to do |format|
      format.html
      format.json { render json: { years: years, contributions: contributions } }
    end
  end

  def activities
    start_date = current_user.account.created_at.to_date.to_s
    end_date = Date.today.to_s
    account = current_user.account.id
    sql = "SELECT s.tag::date AS date , count(t.id) AS count FROM  (SELECT generate_series(timestamp '#{start_date}', timestamp '#{end_date}', interval  '1 day') AS tag ) s  LEFT   JOIN events t ON t.created_at::date = s.tag AND t.account_id = #{account} GROUP  BY 1 ORDER  BY 1;"
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
    boundry = max_count / 4
    activities.map do |row|
      {
        date: row["date"],
        count: row["count"],
        color: "#ebedf0",
        intensity: (row["count"] / boundry),
      }
    end
  end
end
