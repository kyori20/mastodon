# frozen_string_literal: true

class ProcessHashtagsService < BaseService
  DEFAULT_HASHTAG = "nitiasa"
  IGNORE_DEFAULT_HASHTAG = "notag"

  def call(status, tags = [])
    records = []

    if status.local?
      tags = Extractor.extract_hashtags(status.text)

      if !tags.include?(DEFAULT_HASHTAG) && !tags.include?(IGNORE_DEFAULT_HASHTAG) && status.public_visibility? && !status.reply? then
        tags << DEFAULT_HASHTAG
        status.update(text: "#{status.text} ##{DEFAULT_HASHTAG}")
      end
    end

    Tag.find_or_create_by_names(tags) do |tag|
      status.tags << tag
      records << tag
      tag.update(last_status_at: status.created_at) if tag.last_status_at.nil? || (tag.last_status_at < status.created_at && tag.last_status_at < 12.hours.ago)
    end

    return unless status.distributable?

    status.account.featured_tags.where(tag_id: records.map(&:id)).each do |featured_tag|
      featured_tag.increment(status.created_at)
    end
  end
end
