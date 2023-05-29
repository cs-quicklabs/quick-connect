class Report::RatingsController < Report::BaseController
  def index
    authorize :report

    contributions = contributions(ratings)
    years = years(ratings)
    @type = params[:type]
    respond_to do |format|
      format.html
      format.json { render json: { years: years, contributions: contributions } }
    end
  end

  def ratings
    start_date = current_user.account.created_at.to_date.to_s
    end_date = Date.today.to_s
    account = current_user.account.id
    table_name = "ratings"
    sql = "SELECT s.tag::date AS date , COALESCE(t.rating,null) AS rating FROM  (SELECT generate_series(timestamp '#{start_date}', timestamp '#{end_date}', interval  '1 day') AS tag ) s  LEFT   JOIN #{table_name} t ON t.created_at::date = s.tag AND t.user_id IN ( Select id from users where account_id = #{account}) GROUP  BY 1,2 ORDER  BY 1"
    result = ActiveRecord::Base.connection.execute(sql)
  end

  def years(ratings)
    years = ratings.map { |row| row["date"].to_date.year }.uniq

    years.map do |year|
      {

        year: year.to_s,
        total: ratings.select { |row| row["date"].to_date.year == year && !row["rating"].nil? }.map { |row| row["rating"] }.count,
        range: {
          start: Date.new(year, 1, 1).to_s,
          end: Date.new(year, 12, 31).to_s,
        },
      }
    end
  end

  def contributions(ratings)
    ratings.map do |row|
      {
        date: row["date"],
        count: row["count"],
        intensity: row["rating"].nil? ? 0 : 1,
        color: case row["rating"]
        when 0
          "#22c55e"
        when 1
          "#9e9e9e"
        when 2
          "#e53935"
        else
          "#ebedf0"
        end,
      }
    end
  end
end