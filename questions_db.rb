require 'singleton'
require 'sqlite3'
require 'byebug'
require_relative 'user'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true

    self.type_translation = true
  end
end
