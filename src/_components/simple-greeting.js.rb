class SimpleGreeting < LitElement
  custom_element "simple-greeting"

  self.styles = <<~CSS
    p { color: blue }
  CSS

  def initialize
    @name = "Somebody"
  end

  def render
    <<~HTML
      <p>Hello, #{self.name}!</p>
    HTML
  end
end
