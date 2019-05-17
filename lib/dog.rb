class Dog 
  attr_accessor :id, :name, :breed 
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql =  <<-SQL
      DROP TABLE IF EXISTS dogs
        SQL
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO #{self.class.table_name} (name, breed)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{self.class.table_name}").flatten.first
    end
    self
  end
  
  def self.create(name:, breed:)
    dog = self.new(name:name, breed:breed)
    dog.save
    dog
  end
  
  
  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !dog.empty?
      dog_data = dog[0]
      dog = Song.new(dog_data[0], dog_data[1], dog_data[2])
    else
      song = self.create(name: name, breed: breed)
    end
    dog
  end 
  
  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    dog = Song.new({id: result[0], name: result[1], breed: result[2]})
    dog
  end
  
  
  
  
end