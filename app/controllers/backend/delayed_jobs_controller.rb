# -*- coding: utf-8 -*-
require 'fileutils'

class Backend::DelayedJobsController < Backend::BackendController
  

  def index
    @jobs = []
    @queues = Delayed::Job.select(:queue).uniq{|j| j.queue}.map{|j| j.queue}.sort
    queue_index = params[:queue_index] ? params[:queue_index].to_i : 0    
    @djs = Delayed::Job.where('queue=?', @queues[queue_index]).paginate(page: params[:page],
                                  order: "created_at DESC",
                                  limit: Setting.backend_records_per_page)     
    @djs.each do |job|      
      description = YAML::load(job.handler).getDescription     
      if job.last_error.nil? 
        if job.locked_at.nil?
          status = :wait
        else
          status = :run
        end
      else
        if job.attempts == 1 
          status = :repeat
        elsif job.attempts >= 2
          status = :fail
        end         
      end
      @jobs.push({id: job.id, description: description, priority: job.priority,
          status: status, locked_at: job.locked_at, run_at: job.run_at})
      @jobs.last.merge!(last_error: job.last_error.slice(0, job.last_error.index('.') + 1)) if job.last_error
    end
  end

  #restart job
  def update
    if request.xhr?
      model = Delayed::Job.find(params[:id])
      job = YAML::load(model.handler)
      Delayed::Job.enqueue(job, :queue => model.queue)
      model.destroy
    else
      not_found
    end
    render nothing: true
  end  

  #destroy selected jobs
  def destroy
    params[:destroy_jobs] && params[:destroy_jobs].each do |id|
      job = Delayed::Job.find(id)
      if job.queue == 'converting'
        local_file_path = YAML::load(job.handler).local_path
        local_dir = File.dirname(local_file_path)
        if File.exists?(local_file_path)
          File.delete(local_file_path) 
          FileUtils.rm_rf(local_dir) if Dir[File.join(local_dir, '*')].empty? 
        end
      end
      job.destroy      
    end    
    respond_to do |format|
      format.html{redirect_to backend_delayed_jobs_path}
    end
  end
end