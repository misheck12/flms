module DashboardHelper
  def role_based_navigation
    case current_user.role
    when 'admin'
      admin_navigation
    when 'referee'
      referee_navigation
    when 'team'
      team_navigation
    else
      content_tag(:p, "Unauthorized access.")
    end
  end

  private

  def admin_navigation
    content_tag(:ul, class: "navigation") do
      concat content_tag(:li, link_to('Leagues', leagues_path))
      concat content_tag(:li, link_to('Teams', teams_path))
      concat content_tag(:li, link_to('Referees', referees_path))
      concat content_tag(:li, link_to('Matches', matches_path))
    end
  end

  def referee_navigation
    content_tag(:ul, class: "navigation") do
      concat content_tag(:li, link_to('Assigned Matches', referee_matches_path))
      concat content_tag(:li, link_to('Submit Report', new_referee_report_path))
      concat content_tag(:li, link_to('Unclaimed Matches', unclaimed_matches_path))
    end
  end

  def team_navigation
    content_tag(:ul, class: "navigation") do
      concat content_tag(:li, link_to('Upcoming Matches', team_matches_path))
      concat content_tag(:li, link_to('Team Players', team_players_path))
      concat content_tag(:li, link_to('League Standings', league_standings_path))
    end
  end
end
