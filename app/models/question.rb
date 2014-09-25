class Question < ActiveRecord::Base
  validates :body, :poll_id, presence: true

  belongs_to( :poll,
  class_name: 'Poll',
  foreign_key: :poll_id,
  primary_key: :id
  )

  has_many( :answer_choices,
  class_name: 'AnswerChoice',
  foreign_key: :question_id,
  primary_key: :id
  )

  has_many :responses, through: :answer_choices, source: :responses

  def shitty_results
    # n + 1
    results = Hash.new(0)
    choices = self.answer_choices
    choices.each do |answer_choice|
      results[answer_choice] += answer_choice.responses.count
    end
    results
  end

  def less_shitty
    choice_and_responses = self.answer_choices.includes(:responses)
    results = Hash.new(0)

    choice_and_responses.each do |answer_choice|
      results[answer_choice] += answer_choice.responses.length
    end

    results
  end

  def the_best
    # seequel = <<-SQL
   #    SELECT
   #      answer_choices.*, COUNT(responses) AS response_count
   #    FROM
   #      answer_choices
   #    LEFT OUTER JOIN
   #      responses
   #    ON
   #      responses.answer_choice_id = answer_choices.id
   #    WHERE
   #      answer_choices.question_id = ?
   #    GROUP BY
   #      answer_choices.id
   #  SQL
   #
   #  results = AnswerChoice.find_by_sql([seequel, self.id])
   #
   #  results.map do |response|
   #        [response.answer, response.response_count ]
   #      end

    answer_choices_with_count = self.answer_choices
        .select("answer_choices.*, COUNT(responses.id) AS response_count")
        .joins("LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id")
        .group("answer_choices.id")

        answer_choices_with_count.map do |response|
          [response.answer, response.response_count ]
        end
  end

end