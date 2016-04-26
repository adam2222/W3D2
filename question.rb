require 'sqlite3'
require_relative 'questions_db'
require_relative 'reply'
require_relative 'user'
require_relative 'like'
require_relative 'follow'

class Question
  attr_accessor :id, :title, :body, :author_id

  def author
    result = QuestionsDatabase.instance.execute(<<-SQL, @author_id)
      SELECT
        users.*
      FROM
        users
      WHERE
        users.id = ?
    SQL

    User.new(result.first)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

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

  def replies
    Reply.find_by_question_id(@id)
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


  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.author_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end



  def initialize(input_hash = {})
    @id = input_hash['id'].to_i
    @title = input_hash['title']
    @body = input_hash['body']
    @author_id = input_hash['author_id'].to_i
  end
end
