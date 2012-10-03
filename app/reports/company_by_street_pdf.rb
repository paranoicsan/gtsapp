# Encoding: utf-8
class ReportCompanyByStreetPDF < Prawn::Document
  def to_pdf
    # привязываем шрифты
    s = "#{Rails.root}/lib/fonts"
    font_families.update(
        "Verdana" => {
            :bold => "#{s}/verdanab.ttf",
            :italic => "#{s}/verdanai.ttf",
            :normal  => "#{s}/verdana.ttf" })
    font "Verdana", :size => 10

    text "Рога и копыта", :align => :center
    text "Address: аываыаыва"
    text "Email: ваффафафафаыаыв"

    render
  end
end