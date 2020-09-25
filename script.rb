def main
  filenames = ["files/1.txt", "files/2.txt"]
  files = filenames.map { |name| File.open(name, "r") }
  result = File.open("files/solution.txt", "w")

  buffer = files.map do |file|
    read_next_int(file)
  rescue EOFError
    Float::INFINITY # помечаем бесконечностью недоступные к чтению файлы
  end

  # Прекращаем работу если в буфферe все элементы бесконечность
  while(!buffer.all? { |n| n == Float::INFINITY })
    # Находим минимум и его индекс
    min = buffer.min
    i = buffer.index(min)

    # пишем минимум в результирующий файл
    result.puts(min)

    # Если iй файл закончился то помечаем его буффер бесконечностью
    if files[i].eof?
      buffer[i] = Float::INFINITY
      next
    end
    
    # Читаем следующее число из файла где нашли минимум
    buffer[i] = read_next_int(files[i])
  end

  result.close
end

def read_next_int(file)
  loop do
    str = file.readline

    return Integer(str) if  str != "\n"
  end
end

main
