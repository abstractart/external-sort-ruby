class Node
  attr_accessor :next, :value

  def initialize(val, next_node = nil)
    @value = val
    @next = next_node
  end
end

class LinkedList
  def initialize
    @head = @tail = nil
  end

  def push(val)
    if empty?
      @head = @tail = Node.new(val)
    else
      @tail.next = Node.new(val)
      @tail = @tail.next
    end
  end

  def pop
    raise "list is empty" if empty?

    node = @head
    if @head == @tail
      @head = @tail = nil
    else
      @head = @head.next
    end

    node.value
  end

  def get
    raise "list is empty" if empty?

    @head.value
  end

  def empty?
    @head == @tail && @head == nil
  end
end
