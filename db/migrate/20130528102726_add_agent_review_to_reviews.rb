class AddAgentReviewToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :agent_review, :string
  end
end
