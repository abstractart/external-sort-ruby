require_relative 'external_sort'

filenames = ["files/1.txt", "files/2.txt", "files/3.txt"]

filenames.each do |filename|
  ExternalSort.call(filename)
end

FileHelpers.merge_files(*filenames, 'files/solution.txt')
