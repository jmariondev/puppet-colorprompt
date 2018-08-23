# == Class: colorprompt
#
# This module adds colors to the user and host portions of the PS1 prompt.
#
# === Parameters
#
# [*ensure*]
#   Control if this module's functionality is active.
#   Type: String
#   Default: 'present'
#
# [*path*]
#   Path to the colorprompt.sh file.
#   Type: String
#   Default: '/etc/profile.d/colorprompt.sh'
#
# [*default_usercolor*]
#   Sets a color for all users. Specific user colors can be overridden
#   by 'custom_usercolors'.
#   Type: String or Hash
#   Default: undef
#
# [*custom_usercolors*]
#   Sets the color for specific users.
#   Type: Hash
#   Default: { 'root' => 'red' }
#
# [*host_color*]
#   Which color to use for the host portion of the prompt.
#   Type: String or Array
#   Default: undef
#
# [*env_name*]
#   The string added to the beginning of the prompt, 'DEV', 'PROD', etc.
#   Type: String
#   Default: undef
#
# [*env_color*]
#   Color of the string added to the beginning of the prompt, see 'env_name'.
#   Type: String or Array
#   Default: undef
#
# [*prompt*]
#   Format of the $PS1 variable. Use ${env}, ${userColor} and ${hostColor}.
#   Type: String
#   Default:
#   '${env}[${userColor}\u\[\e[0m\]@${hostColor}\h\[\e[0m\] \w]\\$ ' on RedHat
#   '${env}[${userColor}\u\[\e[0m\]@${hostColor}\h\[\e[0m\] \W]\\$ ' on Debian
#
# [*modify_skel*]
#   Comments out PS1 variables in /etc/skel/.bashrc on Debian distributions.
#   Type: Boolean
#   Default: true on Debian, false on RedHat
#
# [*modify_root*]
#   Comments out PS1 variables in /root/.bashrc on Debian distributions.
#   Type: Boolean
#   Default: true on Debian, false on RedHat
#
# === Examples
#
#  class { 'colorprompt':
#     ensure            => present,
#     env_name          => 'PROD',
#     env_color         => ['white', 'bg_red'],
#     host_color        => 'red',
#     custom_usercolors => {
#       'root' => 'red',
#     },
#  }
#
# === Authors
#
# Gjermund Jensvoll <gjerjens@gmail.com>
# John Marion <jmarion-ext@arista.com>
#
# === Copyright
#
# Copyright 2014-2015 Gjermund Jensvoll
# Copyright 2018 John Marion
#
class colorprompt (
  String $ensure                                           = $colorprompt::params::ensure,
  String $path                                             = $colorprompt::params::path,
  # Oof, trying to turn a formerly-duck-typed language into a formally-typed
  # language creates some fun declarations!
  Variant[Undef, String, Array[String]] $default_usercolor = $colorprompt::params::default_usercolor,
  Variant[Undef, Hash[String, String]] $custom_usercolors  = $colorprompt::params::custom_usercolors,
  Variant[Undef, String, Array[String]]] $host_color       = $colorprompt::params::host_color,
  Optional[String] $env_name                               = $colorprompt::params::env_name,
  Variant[Undef, String, Array[String]]] $env_color        = $colorprompt::params::env_color,
  String $prompt                                           = $colorprompt::params::prompt,
  Boolean $modify_skel                                     = $colorprompt::params::modify_skel,
  Boolean $modify_root                                     = $colorprompt::params::modify_root,
) inherits colorprompt::params {
  file { 'colorprompt.sh':
    ensure  => $ensure,
    path    => $path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('colorprompt/colorprompt.erb'),
  }

  if $modify_skel {
    exec { 'modify_skel':
      command     => 'sed -i \'/^if \[ "\$color_prompt" = yes \]; then/,/fi/s/^/#/\' /etc/skel/.bashrc',
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      refreshonly => true,
      subscribe   => File['colorprompt.sh'],
    }
  }

  if $modify_root {
    exec { 'modify_root':
      command     => 'sed -i \'/^if \[ "\$color_prompt" = yes \]; then/,/fi/s/^/#/\' /root/.bashrc',
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      refreshonly => true,
      subscribe   => File['colorprompt.sh'],
    }
  }
}
