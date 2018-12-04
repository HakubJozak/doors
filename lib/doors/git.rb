require 'open3'
require 'date'

# FIXME: use lock file and wait for other GIT operations to finish?
class Doors::Git

  class SyncFailure < RuntimeError
    def initialize(out,err)
      @out = out
      @err = err
    end

    def message
      "STDOUT: #{@out}\nSTDERR:#{@err}"
    end
  end

  def initialize(config, store)
    @config = config
    init! unless repo_exists?
  end

  def inline
    tap {
      @inline = true
    }
  end

  def branch
    @config.git.branch
  end

  def repo
    @config.git.repo
  end

  def sync!
    info 'Syncing GIT'

    detach {
      git "fetch"
      git "checkout #{branch}"
      commit_all
      git "merge origin/#{branch}"
      git "push origin #{branch}"
    }
  end

  def init!
    info 'Initializing GIT repo'

    detach {
      git 'init'
      git "remote add origin #{repo}"
      system "touch #{@config.root}/.gitignore"
      git 'add .'
      git "checkout -b #{branch}"
      git 'commit -m Initial'
      git "push -u origin #{branch}"
    }
  end

  private

    def info(msg)
      tag = '[detached]' unless @inline
      puts [ tag, msg ].join(' ')
    end

    # TODO: add --no-detach parameter to CLI
    def detach(&block)
      if @inline
        block.call
      else
        fork &block
      end
    end

    def commit_all
      msg = "#{`hostname`.strip}-#{DateTime.now.rfc3339}"
      git "commit -m '#{msg}'", quiet: true

      unless @out =~ /nothing.to.commit/
        ensure_success!
      end
    end

    # def stash_save
    #   git 'stash', quiet: true
    # end

    # def stash_pop
    #   git 'stash pop', quiet: true

    #  unless @err =~ /No stash entries/
    #     ensure_success!
    #   end
    # end

    def repo_exists?
      File.exists? "#{@config.root}/.git"
    end

    def git(cmd, quiet: false)
      shell = "git --no-pager -C #{@config.root} #{cmd}"
      @out, @err, @status = Open3.capture3(shell)

      # TODO: logger
      if @inline
        puts shell
      end

      ensure_success! unless quiet
    end

    def ensure_success!
      raise SyncFailure.new(@err,@out) unless @status.exitstatus.zero?
    end

end
