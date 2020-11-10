class Node
  attr_accessor :next, :prev, :value

  def initialize(val, prev_node = nil, next_node = nil)
    @value = val
    @next = next_node
    @prev = prev_node
  end
end

class Deque
  EmptyError = Class.new(StandardError)

  def initialize
    @head = @tail = nil
  end

  def push_back(val)
    node = Node.new(val, self.tail)

    if empty?
      self.head = self.tail = node
    else
      self.tail.next = node
      self.tail = node
    end
    nil
  end

  def push_front(val)
    node = Node.new(val, nil, self.head)

    if empty?
      self.head = self.tail = node
    else
      self.head.prev = node
      self.head = node
    end
    nil
  end

  def pop_back
    raise EmptyError if empty?

    node = self.tail

    if one?
      self.head = self.tail = nil
    else
      self.tail = self.tail.prev
      self.tail.next = nil
    end

    node.value
  end

  def pop_front
    raise EmptyError if empty?

    node = self.head

    if one?
      self.head = self.tail = nil
    else
      self.head = self.head.next
      self.head.prev = nil
    end

    node.value
  end

  def empty?
    self.head.nil?
  end

  def one?
    !empty? && self.head.next.nil?
  end

  private

  attr_accessor :head, :tail
end
