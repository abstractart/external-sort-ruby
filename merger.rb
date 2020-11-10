require_relative 'writer'

module Merger
  BATCH_SIZE = 5
  module_function

  def call(filenames, path)
    files = filenames.map { |name| File.open(name, "r") }
    result = File.open(path, "w")

    merge(files, result)

    files.each(&:close)
    result.close
  end

  def merge(inputs, output)
    batch = []
    buffers = inputs.map { |f| Buffer.new(f) }

    while(!buffers.all?(&:empty?))
      batch << find_minimum(buffers)

      if batch.size == BATCH_SIZE
        Writer.call(output, batch)
        batch = []
      end
    end

    if batch.size > 0
      Writer.call(output, batch)
      batch = []
    end
  end

  def find_minimum(buffers)
    min_value, min_buffer = nil, nil
    buffers.each do |buffer|
      next if buffer.empty?

      if min_value.nil?
        min_value, min_buffer = buffer.pop, buffer
        next
      end

      val = buffer.pop
      if val < min_value
        min_buffer.push(min_value)
        min_value, min_buffer = val, buffer
      else
        buffer.push(val)
      end
    end

    min_value
  end
end
