require_relative 'linked_list'
require_relative 'file_helpers'

class Buffer
  def initialize(io, size = 5)
    @io = io
    @queue = LinkedList.new

    size.times do
      break if @io.eof?
      @queue.push(FileHelpers.read_next_int(io))
    end
  end

  def get
    raise "buffer is empty" if empty?

    queue.get
  end

  def pop
    queue.push(FileHelpers.read_next_int(io)) unless io.eof?

    raise "buffer is empty" if empty?

    queue.pop
  end

  def empty?
    queue.empty? && io.eof?
  end

  private

  attr_reader :io, :queue
end
