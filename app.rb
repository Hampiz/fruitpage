require 'sinatra'
require 'slim'
require 'sinatra/reloader'

get ('/home') do
    slim(:home)
end

get ('/about') do
    slim(:about)
end

get ('/test') do
    @fruitdata = "hamps"
    slim(:test)
end

get ('/fruits/:id') do
    fruits = ["banan", "melon", "kiwi", "citron"]
    id = params[:id].to_i
    @fruit = fruits[id]
    slim(:fruits)
end