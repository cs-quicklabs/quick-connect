module ApplicationHelper
  include Pagy::Frontend
  include AutoLinkHelper
  include Extractor::HashTag

  def tailwind_form_with(**options, &block)
    form_with(**options.merge(builder: TailwindFormBuilder), &block)
  end

  def display_created_at(resource)
    display_date(resource.created_at)
  end

  def display_image(resource)
    if resource.last_name
      resource.first_name[0, 1].upcase_first + resource.last_name[0, 1].upcase_first
    else
      resource.first_name[0]
    end
  end

  def display_date(date)
    date.to_date.to_formatted_s(:long)
  end

  def goal_path(goal)
    if goal.goalable_type == "Project"
      project_milestones_path(goal.goalable)
    else
      employee_goals_path(goal.goalable)
    end
  end

  def highlight_hashtag(title)
    hashtags = extract_hashtags(title)
    highlight(title, hashtags.map { |tag| "#" + tag })
  end

  def auto_link_urls_in_text(text)
    auto_link(text, html: { class: "text-indigo-700 hover:underline", target: "_blank" })
  end

  def login_options
    @redirect_path ? { redirect_to: @redirect_path } : {}
  end

  def convert_string_to_url(text)
    uri_reg = URI.regexp(%w[http https])
    text.gsub(uri_reg) { %{#{$&}'} }
  end

  def ensure_protocol(url)
    if url[/\A(http|https):\/\//i]
      url
    else
      "http://" + url
    end
  end

  def delete_button(path)
    out = link_to "Delete", path, class: "btn-inline-delete", data: {
                                    controller: "confirmation",
                                    "turbo-method": :delete,
                                    "confirmation-message-value": "Are you sure you want to delete this?",
                                    action: "confirmation#confirm",
                                  }

    out.html_safe
  end

  def clear_button(path)
    out = link_to "Clear", path, class: "btn-inline-delete", data: {
                                   controller: "confirmation",
                                   "turbo-method": :delete,
                                   "confirmation-message-value": "Are you sure you want to clear it?",
                                   action: "confirmation#confirm",
                                 }

    out.html_safe
  end

  def styled_delete_button(path, style)
    out = link_to "Delete", path, class: style, data: {
                                    controller: "confirmation",
                                    "turbo-method": :delete,
                                    "confirmation-message-value": "Are you sure you want to delete this?",
                                    action: "confirmation#confirm",
                                  }

    out.html_safe
  end

  def confirm_button(path, title, message, style)
    out = link_to title, path, class: style, data: {
                                 controller: "confirmation",
                                 "confirmation-message-value": message,
                                 action: "confirmation#confirm",
                               }

    out.html_safe
  end

  def edit_button(path)
    out = link_to "Edit", path, class: "btn-inline-edit"

    out.html_safe
  end

  def styled_edit_button(path, style)
    out = link_to "Edit", path, class: style

    out.html_safe
  end

  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def days_in_month(month, year = Time.now.year)
    return 29 if month == 2 && Date.gregorian_leap?(year)
    COMMON_YEAR_DAYS_IN_MONTH[month]
  end

  def github_contributions_canvas(username)
    github_contributions(username).html_safe
  end
end
