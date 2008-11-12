# Tum haklari serbesttir.
# cduruk, wizard


require 'rubygems'
require 'mechanize'
require 'hpricot'

if ARGV.length < 2
  puts "Kullanici adi ve sifre girmen lazim."
  exit
end

agent = WWW::Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
  }

page = agent.get 'http://www.guncem.com'

form = page.forms.first

form['nick'] = ARGV[0]
form['pass'] = ARGV[1]
doc = form.click_button

result = Hpricot(doc.root.to_s)

if !((result/".f")[5].inner_html.strip).include? "Yorumunu"
  puts "Yorumunu okumadigin gunceler var."
else
  puts "Yorumunu okumadigin gunce yok."
end

# after the 5th match, existence of the remaining information blocks are not guaranteed
# instead of static conditional blocks, dynamic pattern matching rules can be applied

definitions = [
    {:pattern => "yorumdan sonra", :text_found => "Senden sonra yapilmis yorumlar var.", :text_notfound => "Senden sonra yapilmis yorum yok.", :found => false},
    {:pattern => "tane yeni mesaj", :text_found => "Okumadigin mesajlar var.", :text_notfound => "Okumadigin mesaj yok.", :found => false},
    {:pattern => "yeni yorum", :text_found => "Kullanici sayfanda yeni yorumlar var.", :text_notfound => "Kullanici sayfanda yeni yorum yok.", :found => false},
    {:pattern => "listesine eklemek isteyen", :text_found => "Dost talepleri var.", :text_notfound => "Dost talebi yok.", :found => false}
]

containers = (result/".f")
containers.each do |container|
    definitions.length.times do |i|
        if (container.innerText).include? definitions[i][:pattern]
            definitions[i][:found] = true
        end
    end
end

definitions.each do |definition|
    if definition[:found]
        puts definition[:text_found]
    else
        puts definition[:text_notfound]
    end
end