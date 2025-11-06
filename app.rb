require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'sqlite3'

#Ta bort en frukt
post ('/fruits/:id/delete') do
#hämta frukten
    id = params[:id].to_i
#koppla till databasen
    db = SQLite3::Database.new("db/fruits.db")
    db.execute("DELETE FROM fruits WHERE id = ?", id)
    redirect('/fruits')
end

post('/fruits/:id/update') do
    #plocka upp id, name och amount
    id = params[:id].to_i
    name = params[:name]
    amount = params[:amount].to_i
    #koppla till databasen
    db = SQLite3::Database.new("db/fruits.db")
    db.execute("UPDATE fruits SET name = ?, amount = ? WHERE id = ?",[name,amount,id])
    #slutligen, redirect till fruits
    redirect('/fruits')
end

get('/fruits/:id/edit') do
    #koppla till databasen
    db = SQLite3::Database.new("db/fruits.db")
    db.results_as_hash = true
    id = params[:id].to_i
    #@ innebär instansvariabel
    @special_frukt = db.execute("SELECT * FROM fruits WHERE id = ?", id).first
    #visa formulär för att uppdatera
    slim(:"fruits/edit")
end

get('/animals/:id/edit') do
    #koppla till databasen
    db = SQLite3::Database.new("db/animals.db")
    db.results_as_hash = true
    id = params[:id].to_i
    #@ innebär instansvariabel
    @special_djur = db.execute("SELECT * FROM animals WHERE id = ?", id).first
    #visa formulär för att uppdatera
    slim(:"animals/edit")
end

post('/animals/:id/update') do
    #plocka upp id, name och amount
    id = params[:id].to_i
    name = params[:name]
    amount = params[:amount].to_i
    #koppla till databasen
    db = SQLite3::Database.new("db/animals.db")
    db.execute("UPDATE animals SET name = ?, amount = ? WHERE id = ?",[name,amount,id])
    #slutligen, redirect till animals
    redirect('/animals')
end

post ('/animals/:id/delete') do
    #hämta djuret
        id = params[:id].to_i
    #koppla till databasen
        db = SQLite3::Database.new("db/animals.db")
        db.execute("DELETE FROM animals WHERE id = ?", id)
        redirect('/animals')
    end


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

get ('/fruits1/:id') do
    fruits = ["banan", "melon", "kiwi", "citron"]
    id = params[:id].to_i
    @fruit = fruits[id]
    slim(:fruits)
end

get ('/fruitinfo') do
    @fruits = [
    {
        "size" => "big",
        "color" => "red"
    },
    {
        "weight" => "67",
        "age" => "2000"
    }
]
    slim(:index)
end

get ('/fruits') do
    query = params[:q]
#gör en koppling till databasen
db = SQLite3::Database.new("db/fruits.db")

#[{}, {}, {}] vill vi ha, inte [[], []]
db.results_as_hash = true

#hämta allt från databasen
@datafrukt = db.execute("SELECT * FROM fruits")

p @datafrukt

if query && !query.empty?
    @datafrukt = db.execute("SELECT * FROM fruits WHERE name LIKE ?", "%#{query}%")
else
    @datafrukt = db.execute("SELECT * FROM fruits")
end

#visa upp med slim
slim(:"fruits/index")
end

get ('/fruits/new') do
slim(:"fruits/new")
end

post ('/fruits') do
    new_fruit = params[:new_fruit]
    amount = params[:amount].to_i
    db = SQLite3::Database.new("db/fruits.db")
    db.execute("INSERT INTO fruits (name, amount) VALUES (?,?)",[new_fruit,amount])
    redirect('/fruits') # Hoppa till routen som visar upp alla frukter
end

get ('/animals') do
    query = params[:a]
#gör en koppling till databasen
db = SQLite3::Database.new("db/animals.db")
    
#[{}, {}, {}] vill vi ha, inte [[], []]
db.results_as_hash = true
    
#hämta allt från databasen
@datadjur = db.execute("SELECT * FROM animals")
    
p @datadjur
    
if query && !query.empty?
    @datadjur = db.execute("SELECT * FROM animals WHERE name LIKE ?", "%#{query}%")
else
    @datadjur = db.execute("SELECT * FROM animals")
end
    
#visa upp med slim
slim(:"animals/index")
end

post ('/animals') do
    new_animal = params[:new_animal]
    amount = params[:amount].to_i
    db = SQLite3::Database.new("db/animals.db")
    db.execute("INSERT INTO animals (name, amount) VALUES (?,?)",[new_animal,amount])
    redirect('/animals') # Hoppa till routen som visar upp alla djur
end

get ('/animals/new') do
    slim(:"animals/new")
    end