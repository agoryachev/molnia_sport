# encoding: utf-8
class CreateDelayedJob < ActiveRecord::Migration
  def self.up
    create_table :delayed_jobs, comment: "Gem delayed_job_active_record" do |table|
      table.integer  :priority, default: 0, comment: "Allows some jobs to jump to the front of the queue"
      table.integer  :attempts, default: 0, comment: "Provides for retries, but still fail eventually."
      table.text     :handler, comment: "YAML-encoded string of the object that will do work"
      table.text     :last_error, comment: "reason for last failure (See Note below)"
      table.datetime :run_at, comment: "When to run. Could be Time.zone.now for immediately, or sometime in the future."
      table.datetime :locked_at, comment: "Set when a client is working on this object"
      table.datetime :failed_at, comment: "Set when all retries have failed (actually, by default, the record is deleted instead)"
      table.string   :locked_by, comment: "Who is working on this object (if locked)"
      table.string   :queue, comment: "The name of the queue this job is in"
      table.timestamps
    end

    add_index :delayed_jobs, [:priority, :run_at], name: 'delayed_jobs_priority'
  end

  def self.down
    drop_table :delayed_jobs
  end
end