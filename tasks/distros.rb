# Distribution (platform) detection

def detect_distro
  # OSX
  if `uname`.chomp == 'Darwin'
    return [:osx, 10.0]
  end

  # Solaris
  if `uname`.chomp == "SunOS"
    return [:solaris, `uname -r`.chomp]
  end

  # Ubuntu
  if File.exist? '/etc/lsb-release'
    info = Hash[ *File.new('/etc/lsb-release').lines.map{ |x| x.split('=').map { |y| y.chomp } }.flatten ]
    if info['DISTRIB_ID'] == 'Ubuntu'
      return [:ubuntu, info['DISTRIB_RELEASE']]
    end
  end

  # Debian
  ver = '/etc/debian_version'
  return [:debian, File.new(ver).readline.chomp] if !File.exist?('/etc/lsb-release') && File.exist?(ver)

  # Fedora
  if File.exist? '/etc/fedora-release'
    release = File.new('/etc/fedora-release').readline.match(/Fedora release (\d+)/)[1]
    return [:fedora, release]
  end

  # Red Hat
  if File.exist? '/etc/redhat-release'
    release = File.new('/etc/redhat-release').readline.match(/Red Hat Enterprise Linux Server release (\d+)/)[1]
    return [:fedora, release]
  end

  # Scientific Linux
  if File.exist? '/etc/redhat-release'
    release = File.new('/etc/redhat-release').readline.match(/Scientific Linux SLF release (\d+)/)[1]
    return [:slf, release]

    if RUBY_VERSION <= '1.8.7'
      raise 'Version of ruby is too old. Consider installing a more recent version'
    end
  end

  # OpenSUSE
  if File.exist? '/etc/SuSE-release'
    release = File.new('/etc/SuSE-release').readline.match(/openSUSE (\d+)/)[1]
    return [:opensuse, release]
  end

  nil
end
