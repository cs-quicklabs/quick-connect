module ReportHelper
  def display_title(title)
    if title == "events"
      "All Events"
    elsif title == "contacts"
      "New Contacts Addition"
    elsif title == "contact_activities"
      "Social Activities"
    elsif title == "contact_events"
      "Life Events"
    elsif title == "conversations" or title == "phone_calls"
      title.gsub("_", " ").titleize
    end
  end
end
