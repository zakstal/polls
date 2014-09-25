class Response < ActiveRecord::Base
  validates :answer_choice_id, presence: true
  validates :user_id, presence: true
  validate :respondent_has_not_already_answered_question

  belongs_to( :responder,
  class_name: 'User',
  foreign_key: :user_id,
  primary_key: :id
  )

  belongs_to( :answer_choice,
  class_name: 'AnswerChoice',
  foreign_key: :answer_choice_id,
  primary_key: :id
  )

  has_one :question, through: :answer_choice, source: :question

  def sibling_responses
    self.question
      .responses
      .where("? IS NULL OR responses.id != ? ", self.id, self.id)
  end

  private

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(:id => self.id)
      errors[:sibling_responses] << "can't have multiple responses"
    end
  end
end