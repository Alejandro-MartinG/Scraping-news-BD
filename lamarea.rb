require 'tweakphoeus'
require 'nokogiri'

class Lamarea
  URL = "http://www.lamarea.com"
  URL_SOC = "#{URL}/secciones/sociedad/"
  N_PAGES = 157


  def initialize
    @http = Tweakphoeus::Client.new()
  end

  def get_notices
    notices = {}
    url = ""

    page = get_page(URL_SOC)
    File.open('notices_la_marea.txt', 'a') do |f|
      (2..N_PAGES).each do |number|
        table = page.css('.main-content-left').css('.main-nosplit')[1]
        table.css('div').each do |notice|
          date = ""
          link = notice.css('.article-header > h2 > a').attr('href').text
          puts link
          title = notice.css('.article-header > h2 > a').text
          puts title
          desc = notice.css('.article-content > p').text
          puts desc
          notices = {
            "date" => date,
            "link" => link,
            "title" => title,
            "desc" => desc
          }
          puts notices
          f.puts notices
          page = get_page("#{URL_SOC}page/#{number.to_s}/")
        end
      end
    end
  end

  def get_page url
    response = @http.get(url)
    Nokogiri::HTML(response.body)
  end

end
