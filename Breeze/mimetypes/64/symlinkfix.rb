#!/usr/bin/env ruby
#
#  Copyright 2015 Harald Sitter <sitter@kde.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License or (at your option) version 3 or any later version
# accepted by the membership of KDE e.V. (or its successor approved
# by the membership of KDE e.V.), which shall act as a proxy
# defined in Section 14 of version 3 of the license.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'pathname'

paths = %w(
  /home/uri/Git/breeze/icons/
  /home/uri/Git/breeze-icon-theme/Breeze/
)

broken = []

%w(icons icons-dark).each do |theme|
  icons = Dir.glob("#{theme}/**/**")
  icons.select! { |icon|  File.symlink?(icon) }

  icons.each do |icon, link = File.readlink(icon)|
    link_base = ''
    skip = false
    paths.each do |path|
      if link.start_with?(path)
        skip = false
        link_base = path
        break
      else
        skip = true
      end
    end
    next if skip

    # Dragons ahead!

    link_pathname = Pathname.new(link)
    next if link_pathname.relative?
    # path relative to stripping base. this is equal to relative to themedir
    link_pathname = link_pathname.relative_path_from(Pathname.new(link_base))
    # icon path relative to themedir
    iconpath = Pathname.new(icon).relative_path_from(Pathname.new(theme))
    # link origin relative to target's directory
    linkorigin = link_pathname.relative_path_from(iconpath.dirname)

    File.delete(icon)
    Dir.chdir(File.dirname(icon)) do
      File.symlink(linkorigin, File.basename(icon))
    end
  end

  icons.each do |icon|
    (broken << "#{icon} => #{File.readlink(icon)}") unless File.exist?(icon)
  end
end

puts "broken: \n  #{broken.join("\n  ")}"
