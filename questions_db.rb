require 'singleton'
require 'sqlite3'
require 'byebug'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true

    self.type_translation = true
  end
end

class User
  attr_accessor :fname, :lname, :id

  def self.all
      results = QuestionsDatabase.instance.execute('SELECT * FROM users')
      @array = results.map { |result| User.new(result) }
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    User.new(result.first)
  end



  def initialize(input_hash = {})
    @id = input_hash['id']
    @fname = input_hash['fname']
    @lname = input_hash['lname']
  end

end

class Question
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    Question.new(result.first)
  end

  def self.find_by_title(title)
    result = QuestionsDatabase.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.title = ?
    SQL

    Question.new(result.first)
  end

  def self.find_by_string(string)
    result = QuestionsDatabase.instance.execute(<<-SQL, string)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.body LIKE ?
    SQL

    Question.new(result.first)
  end



  def initialize(input_hash = {})
    @id = input_hash['id']
    @title = input_hash['title']
    @body = input_hash['body']
    @author_id = input_hash['author_id']
  end
end
