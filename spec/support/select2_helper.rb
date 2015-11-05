def select2_fill_in(selector, options = {})
  input = "/html/body/span/span/span[1]/input"
  select = "//*[@id=\"select2-card_deck_name-results\"]/li"

  page.find(:css, "#{selector} .select2-container").click
  find(:xpath, input).set(options[:with])
  page.find(:xpath, select).click
end