module HistoriesHelper
  def timeline_icon(activity)
    icon_class = case activity.action
    when "user_created"
                  "fa-user"
    when "account_created"
                  "fa-university"
    else
                  "fa-circle"
    end

    content_tag(:i, "", class: "fas #{icon_class}")
  end
end
