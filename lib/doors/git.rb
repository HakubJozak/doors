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

  def initialize(root, store)
    @root = root
    init! unless repo_exists?
  end

  def inline
    tap {
      @inline = true
    }
  end

  def sync!
    info 'Syncing GIT'

    detach {
      stash_save
      git 'pull -r'
      stash_pop
      git 'add .'
      commit
      git "push origin master"
    }
  end

  def init!
    info 'Initializing GIT repo'

    detach {
      git 'init'
      git 'remote add origin git@github.com:HakubJozak/time.git'
      system "touch #{@root}/.gitignore"
      git 'add .'
      git 'commit -m Initial'
      git 'push -u origin master'
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

    def commit
      msg = "#{`hostname`.strip}-#{DateTime.now.rfc3339}"
      git "commit -m '#{msg}'", quiet: true

      unless @out =~ /nothing.to.commit/
        ensure_success!
      end
    end

    def stash_save
      git 'stash', quiet: true
    end

    def stash_pop
      git 'stash pop', quiet: true

     unless @err =~ /No stash entries/
        ensure_success!
      end
    end

    def repo_exists?
      File.exists? "#{@root}/.git"
    end

    def git(cmd, quiet: false)
      shell = "git --no-pager -C #{@root} #{cmd}"
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
