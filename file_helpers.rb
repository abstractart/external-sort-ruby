require_relative 'buffer'

module FileHelpers
  BATCH_SIZE = 5

  module_function

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
    buffers = files.map { |f| Buffer.new(f) }

    buffers.select!{|b| !b.empty?}
    while(!buffers.empty?)
      values = buffers.map(&:get)
      min = values.min

      batch << min
      buffers[values.index(min)].pop

      if batch.size == BATCH_SIZE
        write_to_file(result, batch)
        batch = []
      end

      buffers.select!{|b| !b.empty?}
    end

    if batch.size > 0
      write_to_file(result, batch)
      batch = []
    end
  end
end

