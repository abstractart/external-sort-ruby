require_relative 'external_sort'

def main
  filenames = ["files/1.txt", "files/2.txt", "files/3.txt"]

  # Сортируем каждый файл, результат складываем в новый файл
  sorted_filenames = filenames.map do |filename|
    ExternalSort.call(filename)
  end

  # Сливаем отсортированные файлы в один
  Merger.call(sorted_filenames, 'files/solution.txt')

  # Удаляем неактуальное
  sorted_filenames.each {|f| FileUtils.rm_rf(f) }
end

main

