module JournalHelper
  def journal_status_color(journal)
    bg_color = "bg-gray-100"
    text_color = "text-gray-800"
    if journal.published?
      bg_color = "bg-green-100"
      text_color = "text-green-800"
    else
      bg_color = "bg-red-100"
      text_color = "text-red-800"
    end
    bg_color + " " + text_color
  end
end
