# Tum haklari serbesttir.
# cduruk, wizard
 
require 'rubygems'
require 'mechanize'
require 'hpricot'
require 'handlers' 

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
 
containers = (result/".f")

chain = HandlerChain.new
chain.Add DiaryCommentHandler.new
chain.Add FollowupCommentHandler.new
chain.Add MessageHandler.new
chain.Add UserCommentHandler.new
chain.Add FriendHandler.new
chain.Process containers

if !chain.Handled
  puts "Hic bir yeni gelisme yok"
end