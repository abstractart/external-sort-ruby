module Writer
  module_function

  def call(io, arr)
    io.puts(arr.join("\n"))
  end
end
