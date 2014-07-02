# encoding: utf-8
namespace :remove do

  desc "Окончательно удаляет удаленные (is_deleted = 1) материалы"
  task deleted: :environment do

    Columnist.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
           .destroy_all

    ColumnistPost.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
           .destroy_all

    Gallery.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
           .destroy_all

    Inside.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
           .destroy_all

    InstagramRecord.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
           .destroy_all

    League.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

    Match.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

    Page.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

    Person.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

    Post.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

    Team.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

    Transfer.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

    Tweet.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

    Video.where("is_deleted = 1 AND updated_at < UTC_TIMESTAMP() - INTERVAL 1 DAY")
          .destroy_all

  end

end