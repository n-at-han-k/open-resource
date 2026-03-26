# frozen_string_literal: true

class VStackComponent < Component
  attribute :spacing, :integer, default: 0
  attribute :align,   :string,  default: "start"

  def to_s
    style_parts = [
      "display:flex",
      "flex-direction:column",
      ("gap:#{spacing}px" if spacing > 0),
      ("align-items:#{align_value}" if align != "start")
    ].compact.join(";")

    opts = {}
    opts[:style] = style_parts unless style_parts.empty?

    tag.div(**opts) { @content }
  end

  private

  def align_value
    case align
    when "center" then "center"
    when "end"    then "flex-end"
    when "stretch" then "stretch"
    else "flex-start"
    end
  end
end
