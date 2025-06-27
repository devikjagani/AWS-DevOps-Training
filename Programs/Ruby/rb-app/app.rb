require 'sinatra'

get '/' do
  @name = "Devik Jagani"
  @projects = [
    "Sinatra Portfolio App",
    "Ruby CLI Tool",
    "DevSecOps Automation Script"
  ]
  erb :index
end
