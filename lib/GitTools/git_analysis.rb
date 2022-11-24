require 'ykcitool/helper'

require 'git'
require 'json'

require 'GitTools/git_work_result'

module YKFastlane

  module GitAnalysis

    YKCI_GIT_ROOT_DIR = File.expand_path(File.join(Dir.home, "YKGitCiRoot"))
    include Git

    def self.clone_remote(remote, dest_path)
      if remote.blank?
        puts("No remote")
        return GitAnalysis::GitWorkResult.new(false , nil , "No remote", "No remote")
      end

      if File.exist?(dest_path)
        puts("Local Path existed, remove it first:#{dest_path}")
        FileUtils.rm_r(dest_path, force: true)
      end

      begin
        puts("start clone:#{remote}")
        cloneResult = Git::clone(remote, dest_path, :log => Logger.new(Logger::Severity::INFO))
        puts "clone_result:#{cloneResult}"
      rescue Git::GitExecuteError => e
        puts("clone failed:#{e}")
        return GitWorkResult.new(false , nil , "clone failed", "clone failed:#{remote}") #任务失败
      end

      puts("Clone success !!")
      return GitWorkResult.new(true, nil , "clone success", "clone success")
    end

    def self.commit_tag_diff(path)
      git = Git::open(path)
      last_tag = self.last_tag_on_branch(git)
      tag_name = last_tag.name unless last_tag == nil

      tag_commit = last_tag.log(1).last unless last_tag == nil
      tag_commit = git.log(0x7fffffff).last if tag_commit == nil
      tag_sha = tag_commit.sha unless tag_commit == nil

      cur_commit = git.log(1).first
      cur_sha = cur_commit.sha unless cur_commit == nil

      diff = self.diff_between?(path, tag_sha, cur_sha)

      result = {
        :tag_name => tag_name,
      }
      result.update(diff)
      result
    end


    def commit_tag_diff(path)
    YKFastlane::GitAnalysis.commit_tag_diff(path)
    end

    private

    def self.sha_existed?(git, sha)
      result = true
      begin
        start_type = git.lib.object_type(sha)
      rescue Git::GitExecuteError => e
        result = false
      end
      result
    end

    def self.diff_between?(path, id_start, id_end)
      git = Git::open(path)

      # id_start = "0d5e5d4d7e8f8a9b" #debug code
      # id_end = "2347682023948" #debug code
      status = true
      msg_arr = []
      if self.sha_existed?(git, id_start) == false
        status = false
        msg_arr << id_start
      end

      if self.sha_existed?(git, id_end) == false
        status = false
        msg_arr << id_end
      end

      msg = "success"
      msg = "diff check failed, since commit not existed: " + msg_arr.join(" ") unless status == true

      diff = nil
      if status
        c_start = git.gcommit(id_start)
        c_end = git.gcommit(id_end)
        diff = git.diff(c_start, c_end) #Git::Diff
      end


      remotes = git.remotes
      remote_dict = {}
      remotes.each do |one|
        #Git::Remote
        remote_dict[one.name] = one.url
      end
      result = {
        :status => status,
        :message => msg,
        :remote_info => remote_dict,
        :start_commit => id_start,
        :end_commit => id_end,
        :stats => diff == nil ? {} : diff.stats,
      }

      puts("diff_detail:#{result.to_json}")
      result
    end

    def self.last_tag_on_branch(git)
      last_tag_name = nil

      begin
        last_tag_name = git.describe(nil, { :abbrev => 0 })
      rescue Git::GitExecuteError => e
        puts "find last tag failed:#{e}"
      end
      tag = git.tag(last_tag_name) unless last_tag_name.blank?

      tag
    end

  end
end