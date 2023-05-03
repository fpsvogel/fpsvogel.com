class HappyDays < LitElement
  custom_element "happy-days"

  self.styles = <<~CSS
    :host {
      display: block;
      border: 2px dashed gray;
      padding: 20px;
      max-width: 300px;
    }
  CSS

  def initialize
    @name = "Somebody"
  end

  def render
    <<~HTML
      <p>Hello #{self.name}! #{Date.now()}</p>
    HTML
  end
end
