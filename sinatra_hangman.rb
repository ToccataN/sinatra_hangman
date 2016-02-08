require 'sinatra'
require 'sinatra/reloader'

Dict = File.open("enable.txt")
@@correct = []
@@incorrect = []
@@count = 5

get '/' do   
  @@correct = []
  @@incorrect = []
  @@count = 5

  erb :index
end

post '/' do 
  n = params['number'].to_i
  if n.between?(3,12)
    @@letters = find(n)
    redirect '/game' 
  else
    redirect '/'
  end
  
end

get "/game" do 

          letters = @@letters           
          guess = params['guess']
          correct = @@correct
          if guess != nil
            check_guess(guess, letters)
            if @@incorrect.include?guess
               @@count -= 1
            end
            if  (letters.uniq - correct.uniq).empty?
               redirect '/win'
            end
            if @@count == 0
               redirect '/lose'
            end
            
          end
            disp = display(letters, correct)      
            incorrect = @@incorrect
            count = @@count
          erb :game, :locals => {:letters => letters, :disp => disp, :incorrect => incorrect, :count => count}  
   
end

get '/lose' do 
  letters = @@letters
  erb :lose, :locals => {:letters => letters}
end

get '/win' do
  letters = @@letters
  erb :win, :locals => {:letters => letters}
end

   def find (n)
     words =[]
     dictionary = File.read(Dict)  
     dictionary.scan(/\w+/).each {|word| words << word if word.length == n}
     letters = words.sample.split("").to_a 
     return letters
   end

   def display(letters, correct)
     line = "__"
     d=[]
     @@letters.each do |x| 
       if correct == nil
         d << line
       elsif correct.include?x  
         d << x  
       else
         d << line
       end
     end
     d.join(" ")
   end 


   def check_guess(guess, letters)
     correct = [] 
     if guess != nil   
       if letters.include?guess
         @@correct << guess
       else 
         @@incorrect << guess
       end
     end
     correct
   end
   



