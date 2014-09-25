class Response < ActiveRecord::Base
  validates :answer_choice_id, presence: true
  validates :user_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cannot_respond_to_own_poll

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
    if self.sibling_responses.exists?(:user_id => responder.id)
      errors[:sibling_responses] << "can't have multiple responses"
    end
  end

  def author_cannot_respond_to_own_poll
    if self.question.poll.author.id == self.user_id
      errors[:author] << "cannot respond to own poll"
    end
  end
end