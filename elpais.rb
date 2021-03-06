require 'tweakphoeus'
require 'nokogiri'

class Elpais
  URL = "http://elpais.com"
  URL_SOC = "#{URL}/tag/sociedad/a/"


  def initialize
    @http = Tweakphoeus::Client.new()
  end

  def get_notices
    notices = {}
    url = ""

    page = get_page(URL_SOC)
    puts last_page?(page)
    File.open('notices.txt', 'a') do |f|
      while last_page?(page)
        table = page.css('.columna_principal')
        table.css('.article.estirar').each do |notice|
          date = notice.css('.fecha').text
          link = notice.css('h2 > a').attr("href").text
          title = notice.css('h2 > a').text
          desc = notice.css('p').text
          notices = {
            "date" => date,
            "link" => link,
            "title" => title,
            "desc" => desc
          }
          f.puts notices
        end
        url = next_page(page)
        page = get_page(url)
      end
    end

  end

  def get_page url
    response = @http.get(url)
    Nokogiri::HTML(response.body)
  end

  def next_page page
    URL + page.css('.paginacion > .boton.activo').first.attr('href')
  end

  def last_page? page
    puts page.css('.paginacion > .boton.activo').first.attr('title')
    return true if page.css('.paginacion > .boton.activo').first.attr('title').eql?("Página siguiente")
    false
  end

end
