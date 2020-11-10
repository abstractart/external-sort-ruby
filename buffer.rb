require_relative 'deque'

class Buffer
  def initialize(io, size = 5)
    @io = io
    @deque = Deque.new

    size.times do
      break if @io.eof?
      @deque.push_back(Integer(@io.gets))
    end
  end

  def pop
    deque.push_back(Integer(io.gets)) unless io.eof?
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
