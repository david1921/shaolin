module OffersHelper

  STEP_TITLES = { 1 => 'Choose an offer type, select your objective and enter your offer details',
                  2 => 'Enter your offer details',
                  3 => 'Select your target audience',
                  4 => 'Your offer summary',
                  5 => 'Thank you for submitting your offer.'
  }

  STEP_PERCENTS = { 1 => 15,
                    2 => 40,
                    3 => 60,
                    4 => 85
  }

  def formatted_offer_objectives(offer)
    description_from_objective = {
      'drive_sales' => "Encourage new and existing customers to spend more with you",
      'get_new_customers' => "Based on our data, people who have never shopped with you or have not shopped with you for some time",
      'encourage_repeat_business' => "Encourage your customers to come back again and again"
    }
    content_tag_for(:strong, offer.objective.humanize) + "<br/>#{description_from_objective[offer.objective]}.".html_safe
  end

  def offer_title(step)
    STEP_TITLES[step] if step
  end

  def offer_progress_span(offer, opts={save_button: false})
    return unless offer && STEP_PERCENTS[offer.step]
    percent = STEP_PERCENTS[offer.step]
    save_button = "<button class='save_progress'>Save your progress</button>"
    span = "<span class='percent_#{percent}'>#{percent}%</span>"
    (opts[:save_button] ? save_button + span : span).html_safe
  end
end
