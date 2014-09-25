class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many( :authored_polls,
  class_name: 'Poll',
  foreign_key: :author_id,
  primary_key: :id
  )

  has_many( :responses,
  class_name: 'Response',
  foreign_key: :user_id,
  primary_key: :id
  )

  def completed_polls
    poll_count = <<-SQL

      SELECT
      polls.*, COUNT(questions.id) as question_count, COUNT(ours.id) AS response_count
      FROM
      polls
      INNER JOIN
      questions
      ON
      polls.id = questions.poll_id
      INNER JOIN
      answer_choices
      ON
      answer_choices.question_id = questions.id
      LEFT OUTER JOIN
        (SELECT
            responses.*
            FROM
            responses
            WHERE
            responses.user_id = 1
        ) ours
      ON
      ours.answer_choice_id = answer_choices.id
      GROUP BY
      polls.id
      HAVING
      COUNT(questions.id) = COUNT(ours.id)
    SQL

    Poll.find_by_sql([poll_count, self.id])

  end

end