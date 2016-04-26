require 'sqlite3'
require_relative 'questions_db'
require_relative 'like'
require_relative 'user'
require_relative 'follow'
require_relative 'question'

class Reply
  attr_accessor :author_id, :parent_id, :id, :body

  def initialize(input = {})
    @author_id = input['author_id']
    @parent_id = input['parent_id']
    @id = input['id']
    @body = input['body']
    @question_id = input['question_id']
  end

  def self.find_by_user_id(user_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.author_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end


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

  def question
    result = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
      SELECT
        questions.*
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    Question.new(result.first)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        replies.*
      FROM
        replies
      WHERE
        replies.parent_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def parent_reply
    result = QuestionsDatabase.instance.execute(<<-SQL, @parent_id)
      SELECT
        replies.*
      FROM
        replies
      WHERE
        replies.id = ?
    SQL

    Reply.new(result.first)
  end
end
