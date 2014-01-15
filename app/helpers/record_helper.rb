module RecordHelper
  def render_tab(record)
    content_tag(:ul, class: "nav nav-tabs", id: "tabs") do
      
      render_text = ""

      if record.out_payment
        render_text = 

        content_tag(:li, class: "active") do
          link_to "支出", "#expenseTab", id: "expenseLink","data-toggle" => "tab"
        end +
        content_tag(:li) do
          link_to "收入", "#incomeTab", id: "incomeLink","data-toggle" => "tab"
        end 
      else
        render_text = 

        content_tag(:li) do
          link_to "支出", "#expenseTab", id: "expenseLink","data-toggle" => "tab"
        end +
        content_tag(:li, class: "active") do
          link_to "收入", "#incomeTab", id: "incomeLink","data-toggle" => "tab"
        end 
      end
      render_text
    end
  end
end
