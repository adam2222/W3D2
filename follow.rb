require 'sqlite3'
require_relative 'questions_db'
require_relative 'reply'
require_relative 'user'
require_relative 'like'
require_relative 'question'

class QuestionFollow
  attr_accessor :user_id, :question_id

  def initialize(input = {})
    @user_id = input['user_id']
    @question_id = input['question_id']
  end


  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_follows
      ON
        users.id = question_follows.user_id
      JOIN
        questions
      ON
        questions.id = question_follows.question_id
      WHERE
        questions.id = ?
    SQL

    results.map {|result| User.new(result)}
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        users
      JOIN
        question_follows
      ON
        users.id = question_follows.user_id
      JOIN
        questions
      ON
        questions.id = question_follows.question_id
      WHERE
        users.id = ?
    SQL

    results.map {|result| Question.new(result)}
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        users
      JOIN
        question_follows
      ON
        users.id = question_follows.user_id
      JOIN
        questions
      ON
        questions.id = question_follows.question_id
      ORDER BY
        COUNT(users.id)
      LIMIT
        ?
    SQL

    results.map {|result| Question.new(result)}
  end
end
