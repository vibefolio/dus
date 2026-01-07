
require 'fileutils'

templates_dir = 'app/views/templates'
templates = Dir.glob("#{templates_dir}/*.html.erb")

puts "Analyzing #{templates.count} templates..."

templates.each do |file|
  content = File.read(file)
  name = File.basename(file, '.html.erb')

  # Find colors
  hex_colors = content.scan(/#[0-9a-fA-F]{3,6}/).uniq

  # Find images
  images = content.scan(/src=["'](.*?)["']/).flatten.select { |s| s.start_with?('http') }

  puts "Template: #{name}"
  puts "  Colors: #{hex_colors.take(5).join(', ')}..."
  puts "  Images: #{images.count} found"
  images.each do |img|
    puts "    - #{img}" if img.include?('unsplash')
  end
  puts "-" * 20
end
