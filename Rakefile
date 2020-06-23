# frozen_string_literal: true

INSTALL_DIR = "#{Dir.home}/.local/bin"
INSTALL_LOCATION = "#{INSTALL_DIR}/strofi"

directory INSTALL_DIR
desc 'Installs Strofi to ~/.local/bin/strofi'
task install: [:check_installed, :check_deps] do
  install('strofi.rb', INSTALL_LOCATION)
  chmod('u=wrx,go=rx', INSTALL_LOCATION)
end

desc 'Removes Strofi from ~/.local/bin/strofi'
task :uninstall do
  rm(INSTALL_LOCATION)
end

task :check_installed do
  exit 0 if File.exist?(INSTALL_LOCATION)
end

task :check_deps do
  deps = %w[streamlink rofi mpv]
  deps.each do |dep|
    unless system("which #{dep}")
      puts "Missing Dependency: #{dep}. Aborting..."
      exit 1
    end
  end
end

