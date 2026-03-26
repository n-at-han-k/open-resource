# frozen_string_literal: true

class HStackComponent < Component
  attribute :spacing, :integer, default: 0
  attribute :justify, :string,  default: "start"
  attribute :align,   :string,  default: "start"
  attribute :padding, :integer, default: nil
  attribute :rounded, :string,  default: nil
  attribute :shadow,  :string,  default: nil
  attribute :bg,      :string,  default: nil

  def to_s
    style_parts = [
      "display:flex",
      ("gap:#{spacing}px" if spacing > 0),
      ("justify-content:#{justify_value}" if justify != "start"),
      ("align-items:#{align_value}" if align != "start"),
      ("padding:#{padding}px" if padding),
      ("border-radius:#{rounded_value}" if rounded),
      ("background:#{bg}" if bg)
    ].compact.join(";")

    classes = [
      ("shadow-border-#{shadow}" if shadow)
    ].compact

    opts = {}
    opts[:class] = classes.join(" ") unless classes.empty?
    opts[:style] = style_parts unless style_parts.empty?

    tag.div(**opts) { @content }
  end

  private

  def justify_value
    case justify
    when "center"  then "center"
    when "end"     then "flex-end"
    when "between" then "space-between"
    when "around"  then "space-around"
    when "evenly"  then "space-evenly"
    else "flex-start"
    end
  end

  def align_value
    case align
    when "center"  then "center"
    when "end"     then "flex-end"
    when "stretch" then "stretch"
    when "baseline" then "baseline"
    else "flex-start"
    end
  end

  def rounded_value
    case rounded
    when "sm" then "0.125rem"
    when "md" then "0.375rem"
    when "lg" then "0.5rem"
    when "xl" then "0.75rem"
    when "full" then "9999px"
    else "0.25rem"
    end
  end
end
