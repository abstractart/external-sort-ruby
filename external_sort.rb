require 'securerandom'
require 'fileutils'

require_relative './merger'
require_relative './buffer'
require_relative './writer'

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
      buffer = Buffer.new(file)

      while(!buffer.empty?)
        batch << buffer.pop
        if batch.size == BATCH_SIZE
          files << sort_and_save_batch(batch)
          batch = []
        end
      end
    end

    unless batch.empty?
      files << sort_and_save_batch(batch)
      batch = []
    end

    result_filename = generate_filename
    Merger.call(files, result_filename)
    files.each {|f| FileUtils.rm_rf(f) }

    result_filename
  end

  def sort_and_save_batch(batch)
    batch.sort!
    filename = generate_filename
    File.open(filename, "w") { |file| Writer.call(file, batch) }

    filename
  end

  def generate_filename
    File.join(TMP, SecureRandom.hex + '.txt')
  end
end
