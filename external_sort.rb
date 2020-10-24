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
        batch << FileHelpers.read_next_int(file)

        next if batch.size < BATCH_SIZE

        files << sort_and_save_batch(batch)
        batch = []
      end
    end

    files << sort_and_save_batch(batch) unless batch.empty?

    sorted_file = generate_filename
    FileHelpers.merge_files(*files, sorted_file)

    files.each {|f| FileUtils.rm_rf(f) }

    sorted_file
  end

  def sort_and_save_batch(batch)
    batch.sort!
    filename = generate_filename
    File.open(filename, "w") { |file| FileHelpers.write_to_file(file, batch) }

    filename
  end

  def generate_filename
    File.join(TMP, SecureRandom.hex + '.txt')
  end
end
