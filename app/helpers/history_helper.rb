module HistoryHelper

  def card_history_additions(card_histories)
    return {} if card_histories.empty?
    content = escape_once(render(partial: 'card_history', locals: { card_histories: card_histories }))
    {
      class: 'has-popover dotted-baseline',
      data: {
        container: 'body',
        title: "Cards played (#{card_histories.length})",
        trigger: 'hover',
        placement: 'bottom',
        content: content,
        html: true
      }
    }
  end

  def timeline_additions(result)
    return {} if result.card_histories.empty?
    header = escape_once(render(partial: 'timeline_header', locals: { result: result }))
    content = escape_once(render(partial: 'timeline', locals: { grouped_card_histories: group_card_histories_chronologically(result) }))
    {
      class: 'btn btn-default btn-xs timeline-button',
      data: {
        container: 'body',
        title: header,
        content: content,
        html: true
      }
    }
  end

  private

  def group_card_histories_chronologically(result)
    chronological_card_history = result.card_histories

    groups = []

    current_card_group = []
    current_player = nil

    chronological_card_history.each do |card_history|
      if current_player && current_player != card_history.player
        groups << current_card_group
        current_card_group = []
      end
      current_player = card_history.player
      current_card_group << card_history
    end

    if current_card_group.any?
      groups << current_card_group
    end

    groups
  end
end
