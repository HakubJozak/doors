require 'open3'
require 'date'

# FIXME: use lock file and wait for other GIT operations to finish?
class Doors::Git

  class Error < ::Doors::Error ; end

  class NoSSHKey < Error ; end

  class SyncFailure < Error
    def initialize(out,err)
      @out = out
      @err = err
    end

    def message
      "STDOUT: #{@out}\nSTDERR:#{@err}"
    end
  end

  def initialize(cli)
    @config = cli.config
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

  def checkout!
    return if current_head_branch == branch
    git "checkout #{branch}"
  end

  def sync!
    info 'Syncing GIT'
    ensure_ssh_authenticated!

    detach {
      git "fetch"
      checkout!
      commit_all
      git "merge origin/#{branch}"
      push
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
      push
    }
  end

  private
    def info(msg)
      tag = '[detached]' unless @inline
      puts [ tag, msg ].compact.join(' ')
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
      git "add ."

      msg = "#{`hostname`.strip}-#{DateTime.now.rfc3339}"
      git "commit -m '#{msg}'", quiet: true

      unless @out =~ /nothing.to.commit/
        ensure_success!
      end
    end

    def push
      ensure_ssh_authenticated!
      git "push -u origin #{branch}"
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

      @out
    end

    def current_head_branch
      git("rev-parse --abbrev-ref HEAD").strip
    end

    def ensure_success!
      raise SyncFailure.new(@err,@out) unless @status.exitstatus.zero?
    end

    def ensure_ssh_authenticated!
      return unless (action = @config.git.check_ssh)

      output = `ssh-add -l`

      if output =~ /The agent has no identities/
        if action.downcase == 'ask'
          puts 'Missing SSH identites. Running ssh-add:'.yellow
          system 'ssh-add'
        else
          raise NoSSHKey.
                  new "No SSH identity found. Use ssh-add to add it."
        end
      end
    end


end
