module HashCache
  require 'yaml/store'

  ## 
  #  An ETag cache.
  #
  #  Given a file size, mtime and inode, reply with the previous sha1 hash
  ##
  
  def key(file)
    f = File.stat(file) 
    inode = f.ino
    mtime = f.mtime.to_i
    size  = f.size
    "#{inode}#{mtime}#{size}"
  end

  def hash(file)
    store = YAML::Store.new( File.join(ENV['HOME'], ".ferver.yml"))

    begin
      hash = store.transaction { store.fetch(key(file))}
    rescue PStore::Error
      puts "Generating missing etag / hash for #{file}"
      hash = Digest::SHA1.file(file).hexdigest
      store.transaction { store[key(file)] = hash }
    end

    return hash
  end

end
