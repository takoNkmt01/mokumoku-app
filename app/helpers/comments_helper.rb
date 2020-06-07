module CommentsHelper
  # counts Reply to Comment
  def count_reply_comments(target_comment)
    Comment.where(reply_to: target_comment.id).count
  end

  # select returned comments
  def select_returned_comments(target_comment)
    Comment.where(reply_to: target_comment.id)
  end
end
