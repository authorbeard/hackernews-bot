class HelloWorld < ApplicationJob

  def perform 
    puts "hello world"
  end
end