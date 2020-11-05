require_relative 'buffer'
require 'pry'
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

    while(!buffers.all?(&:empty?))
      minimium_buffer = find_buffer_with_min(buffers)
      batch << minimium_buffer.get
      minimium_buffer.pop

      if batch.size == BATCH_SIZE
        write_to_file(result, batch)
        batch = []
      end
    end

    if batch.size > 0
      write_to_file(result, batch)
      batch = []
    end
  end

  def find_buffer_with_min(buffers)
    min = nil
    buffers.each do |buffer|
      next if buffer.empty?

      min = buffer unless min
      min = buffer if min.get > buffer.get
    end

    min
  end
end

