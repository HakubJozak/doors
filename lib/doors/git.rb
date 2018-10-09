require 'open3'
require 'date'

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

  def sync!
    puts '[detached] Syncing'
    
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
    puts '[detached] Initializing GIT repo'

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

    # TODO: add --no-detach parameter to CLI
    def detach(&block)
      fork &block
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
      # puts shell
      
      ensure_success! unless quiet
    end

    def ensure_success!
      raise SyncFailure.new(@err,@out) unless @status.exitstatus.zero?  
    end

end
