# In order to handle different information containers, the chain-of-responsibility design pattern is used here.
# Any information handler should implement the abstract "Handle" method of the IHandler module which outputs relevant information.

# HandlerChain class is responsible for calling handlers in the given order.
# If the context has been handled by any of the handlers, the "Handled" flag is set.
class HandlerChain
  attr_reader :Handled

  def initialize
    @handlers = Array.new
  end

  def Add(handler)
    @handlers.push handler
  end

  def Process(items)
    @Handled = false
    items.each do |item|
      @handlers.each do |handler|
        if handler.Recognize item.innerText # passing text-only data
          handler.Handle item # passing the actual data
          @Handled = true
          break
        end
      end
    end
  end
end

module IHandler
  def Recognize(content)
    if content =~ @pattern
      true
    else
      false
    end
  end

  def Handle(context)
    raise Exception.new("Not implemented")
  end
end

class DiaryCommentHandler
  include IHandler

  def initialize
    @pattern = /Yorumlar/
  end

  def Handle(context)
    puts "Gunce Yorumlari \t\t VAR."
  end
end

class FollowupCommentHandler
  include IHandler

  def initialize
    @pattern = /yorumdan sonra/
  end

  def Handle(context)
    puts "Yeni Yorum \t\t VAR."
  end
end

class MessageHandler
  include IHandler

  def initialize
    @pattern = /tane yeni mesaj/
  end

  def Handle(context)
    puts "Yeni Mesaj \t\t VAR."
  end
end

class UserCommentHandler
  include IHandler

  def initialize
    @pattern = /yeni yorum/
  end

  def Handle(context)
    puts "Yeni Kullanici Yorumu \t\t VAR."
  end
end

class FriendHandler
  include IHandler

  def initialize
    @pattern = /listesine eklemek isteyen/
  end

  def Handle(context)
    puts "Dost Talebi \t\t VAR."
  end
end
