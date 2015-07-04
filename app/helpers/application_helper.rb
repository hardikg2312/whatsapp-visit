module ApplicationHelper

  def days_ago(date)
    time_in_millis = (Time.now - date).to_i
    if time_in_millis < 60*60
      pluralize(time_in_millis/60, 'minute') + ' ago'
    elsif time_in_millis < 24*60*60
      pluralize(time_in_millis/60/60, 'hour') + ' ago'
    elsif time_in_millis < 24*60*60*30
      pluralize(time_in_millis/24/60/60, 'day') + ' ago'
    elsif time_in_millis < 24*60*60*365
      pluralize(time_in_millis/24/60/60/30, 'month') + ' ago'
    else
      pluralize(time_in_millis/24/60/60/365, 'year') + ' ago'
    end
  end
  
end
