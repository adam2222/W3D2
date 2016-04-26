require 'sqlite3'
require_relative 'questions_db'
require_relative 'reply'
require_relative 'question'
require_relative 'like'
require_relative 'follow'

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

  def self.find_by_name(name)
    fname, lname = name.split(" ")
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    User.new(result.first)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def followed_questions
    # results = QuestionsDatabase.instance.execute(<<-SQL, @id)
    #   SELECT
    #     questions.*
    #   FROM
    #     users
    #   JOIN
    #     question_follows
    #   ON
    #     users.id = question_follows.user_id
    #   JOIN
    #     questions
    #   ON
    #     questions.id = question_follows.question_id
    #   WHERE
    #     users.id = ?
    # SQL
    #
    # results.map {|result| Question.new(result)}
    QuestionFollow.followed_questions_for_user_id(@id)
  end


  def initialize(input_hash = {})
    @id = input_hash['id'].to_i
    @fname = input_hash['fname']
    @lname = input_hash['lname']
  end

end
