module FileHelpers
  BATCH_SIZE = 5

  module_function

  def read_next_int_safe(file)
    pos = file.pos
    str = file.gets

    file.seek(pos, IO::SEEK_SET)

    Integer(str)
  end

  def read_next_int(file)
    Integer(file.gets)
  end

  def write_to_file(file, arr)
    file.puts(arr.join("\n"))
  end

  def merge_files(*filenames, path)
    files = filenames.map { |name| File.open(name, "r") }
    result = File.open(path, "w")

    merge(*files, result)

    files.each(&:close)
    result.close
  end

  def merge(*files, result)
    batch = []
    while(!files.all?(:eof?))
      files.select! {|f| !f.eof?}

      if !files.empty?
        buffer = files.map {|f| read_next_int_safe(f) }
        min = buffer.min
        batch << min
        read_next_int(files[buffer.index(min)])
      end

      if batch.size == BATCH_SIZE || files.empty?
        write_to_file(result, batch)
        batch = []
      end
    end

    files.each(&:close)
    result.close
  end
end

