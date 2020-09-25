require 'securerandom'
require 'fileutils'

require_relative './file_helpers'

module ExternalSort
  TMP = "/tmp/"
  BATCH_SIZE = 5

  module_function

  # Идея: читаем файл по частям, каждую часть сортируем и сохраняем в файл
  # Потом объединяем сортированные файлы в один
  def call(filename)
    batch = []
    files = []

    File.open(filename, "r") do |file|
      while(!file.eof?)
        begin
          if batch.size < BATCH_SIZE
            batch << FileHelpers.read_next_int(file)
          else
            files << sort_and_save_batch(batch)
            batch = []
          end
        rescue EOFError
          break
        end
      end
    end

    files << sort_and_save_batch(batch) unless batch.empty?

    FileHelpers.merge_files(*files, filename)

    files.each {|f| FileUtils.rm_rf(f) }

    nil
  end

  def sort_and_save_batch(batch)
    batch.sort!
    filename = File.join(TMP, SecureRandom.hex + '.txt')
    File.open(filename, "w") { |file| FileHelpers.write_to_file(file, batch) }

    filename
  end
end
