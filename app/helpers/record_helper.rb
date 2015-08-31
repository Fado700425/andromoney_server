module RecordHelper
  def render_tab(record)
    content_tag(:ul, class: "nav nav-tabs", id: "tabs") do
      
      render_text = ""

      if record.out_payment && !record.in_payment  #expense
        render_text = 
        content_tag(:li, class: "active") do
          link_to t('record_type.expense'), "#expenseTab",   class: "editLink", id: "expenseLink", "data-toggle" => "tab", "data-token" => "expense"
        end
      elsif !record.out_payment && record.in_payment  #income
        render_text = 
        content_tag(:li, class: "active") do
          link_to t('record_type.income'), "#incomeTab",     class: "editLink", id: "incomeLink", "data-toggle" => "tab", "data-token" => "income"
        end 
      elsif record.out_payment && record.out_payment  #transfer
        render_text = 
        content_tag(:li, class: "active") do
          link_to t('record_type.transfer'), "#transferTab", class: "editLink", id: "transferLink", "data-toggle" => "tab", "data-token" => "transfer"
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

  def default_selected(selected, default = "")
    if selected != nil
      selected
    else
      default
    end
  end
  
end
