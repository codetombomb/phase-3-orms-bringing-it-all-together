require 'pry'

class Dog
    attr_accessor :name, :breed, :id

    def initialize(id: nil, name:, breed:)
        @name = name 
        @breed = breed
        @id = id
    end

    #INSTANCE METHODS
    def save
        sql = 
        <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES ("#{self.name}", "#{self.breed}");
        SQL
        send(sql)
        self.id = send(
            <<-SQL
            SELECT * FROM dogs ORDER BY dogs.id DESC LIMIT 1;
            SQL
            )[0][0]
        self
    end

    #CLASS METHODS
    def self.create_table
        sql = <<-SQL 
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        );
        SQL
        self.send(sql)
    end

    def self.drop_table
        sql = 
        <<-SQL
        DROP TABLE dogs
        SQL
        self.send(sql)
    end

    def self.create(name:, breed:)
        new_new = self.new(name: name, breed: breed)
        new_new.save
    end

    def self.new_from_db(row)
        self.new(id: row[0], name: row[1], breed: row[2])
    end

    def self.all
        dogs = self.get_all
        dogs.map {|d| self.new_from_db(d)}
    end

    def self.find_by_name(name)
        sql = 
        <<-SQL
        SELECT * FROM dogs
        WHERE dogs.name = "#{name}";
        SQL
        self.new_from_db(self.send(sql)[0])
    end

    def self.find(id)
        sql =
        <<-SQL
        SELECT * FROM dogs
        WHERE dogs.id = "#{id}"
        SQL
        self.new_from_db(self.send(sql)[0])
    end

    private

    def self.get_all
        sql =
        <<-SQL
        SELECT * FROM dogs;
        SQL
        self.send(sql)
    end

    def self.send(sql)
        DB[:conn].execute(sql)
    end

    def send(sql)
        DB[:conn].execute(sql)
    end

end
