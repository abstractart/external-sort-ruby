module FileHelpers
  BATCH_SIZE = 5

  module_function

  def read_next_int(file)
    loop do
      str = file.readline

      return Integer(str) if  str != "\n"
    end
  end


  def write_to_file(file, arr)
    file.puts(arr.join("\n"))
  end

  def merge_files(*filenames, path)
    files = filenames.map { |name| File.open(name, "r") }
    result = File.open(path, "w")
    batch = []
    buffer = files.map do |file|
      read_next_int(file)
    rescue EOFError
      Float::INFINITY # помечаем бесконечностью недоступные к чтению файлы
    end

    # Прекращаем работу если в буфферe все элементы бесконечность
    while(!buffer.all? { |n| n == Float::INFINITY })
      # Находим минимум и его индекс
      min = buffer.min

      # пишем минимум в кэш
      batch << min

      # если кэш наполнен, пишем в файл
      if batch.size == BATCH_SIZE
        write_to_file(result, batch)
        batch = []
      end

      i = buffer.index(min)
      # Если iй файл закончился то помечаем его буффер бесконечностью
      if files[i].eof?
        buffer[i] = Float::INFINITY
        next
      end

      # Читаем следующее число из файла где нашли минимум
      buffer[i] = read_next_int(files[i])
    end

    write_to_file(result, batch) if batch.size > 0

    files.each(&:close)
    result.close
  end
end

