# Encoding: utf-8
require "rtf"

class ReportCompanyByStreetRTF < RTF::Document
  def to_rtf
    paragraph do |p|
      p << "This is the first sentence in the paragraph. "
      p << "This is the second sentence in the paragraph. "
      p << "And this is the third sentence in the paragraph."
    end

    super
  end
end