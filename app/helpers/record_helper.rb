module RecordHelper
  def render_tab(record)
    content_tag(:ul, class: "nav nav-tabs", id: "tabs") do
      
      render_text = ""

      if record.out_payment
        render_text = 
        content_tag(:li, class: "active") do
          link_to t('record_type.expense'), "#expenseTab", id: "expenseLink","data-toggle" => "tab"
        end
      else
        render_text = 
        content_tag(:li, class: "active") do
          link_to t('record_type.income'), "#incomeTab", id: "incomeLink","data-toggle" => "tab"
        end 
      end
      render_text
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction} record_head" : "record_head"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def payment_icon(payment_kind)
    if payment_kind == 0
      icon_path = "payment_icon/cash.png"
    elsif payment_kind == 1
      icon_path = "payment_icon/card.png"
    elsif payment_kind == 2
      icon_path = "payment_icon/bank.png"
    end
    return icon_path
  end
  
end
