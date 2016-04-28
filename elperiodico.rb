require 'tweakphoeus'
require 'nokogiri'

class Elperiodico
  URL = "http://www.elperiodico.com"
  URL_SOC = "#{URL}/es/ultimas-noticias/"
  N_PAGES = 22


  def initialize
    @http = Tweakphoeus::Client.new()
  end

  def get_notices
    notices = []
    url = ""

    page = get_page(URL_SOC)
    #puts last_page?(page)
    #while last_page?(page)
    File.open('notices.txt', 'a') do |f|
      (2..N_PAGES).each do |number|
        table = page.css('#cmp-list-last-news-container')
        table.css('.item').each do |notice|
          date = notice.css('.fecha').text
          puts date
          link = URL + notice.css('h2 > a').attr("href").text
          title = notice.css('h2 > a').attr('title').text
          desc = notice.css('.p2').text
          notices << {
            "date" => date,
            "link" => link,
            "title" => title,
            "desc" => desc
          }
          puts notices
          f.puts notices
          page = "#{URL_SOC}cmp-lst-last-news-#{number.to_s}.inc"
        end
      end
    end
    #url = next_page(page)
    #page = get_page(url)
    #end

    #save_info(notices)
  end

  def get_page url
    response = @http.get(url)
    page = Nokogiri::HTML(response.body)
  end

  #def next_page page
  #URL + page.css('.paginacion > .boton.activo').first.attr('href')
  #end

  #def last_page? page
  #puts page.css('.paginacion > .boton.activo').first.attr('title')
  #return true if page.css('.paginacion > .boton.activo').first.attr('title').eql?("Página siguiente")
  #false
  #end

  def save_info notices
    # TODO: save notices in files or ddbb
    a = File.open("notices_elperiódico.txt","w")
    a.write(notices)
    a.close
  end

end
