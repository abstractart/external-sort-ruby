require_relative 'deque'
require_relative 'file_helpers'

class Buffer
  def initialize(io, size = 5)
    @io = io
    @deque = Deque.new

    size.times do
      break if @io.eof?
      @deque.push_back(FileHelpers.read_next_int(@io))
    end
  end

  def pop
    deque.push_back(FileHelpers.read_next_int(io)) unless io.eof?
    deque.pop_front
  end

  def push(val)
    deque.push_front(val)
  end

  def empty?
    deque.empty? && io.eof?
  end

  private

  attr_reader :io, :deque
end
