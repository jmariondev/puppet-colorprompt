# Puppet Color Prompt #

## Overview ##

This module adds colors to the user and host portions of the PS1 prompt.

## Module Description ##

This module adds a script to `/etc/profile.d` to insert terminal colors into
your PS1 prompt variable. This is useful to help differentiate production
system prompts from local prompts.

You haven't lived until you've accidentally shut down a production system! ;)

## Usage ##

### Basic Usage ###

This will install the colorprompt script with the default settings. This will
only color the user portion of the prompt when you are root.

```puppet
include ::colorprompt
```

### Production System in Red ###

This is what you might define for a production system that should show a red
hostname and prepend a red 'PRD' to your prompt:

```puppet
class { '::colorprompt':
  env_name   => 'PRD',
  env_color  => 'red',
  host_color => 'red',
}
```

### Available Colors ###

This module supports the basic colors of an 8-color terminal, which should be
pretty universally supported:

* black
* red
* green
* yellow
* blue
* magenta
* cyan
* white

All of these are also available as background colors by adding 'bg_' to the
beginning of the color name, eg `bg_yellow`.

A few styles are also supported:

* bright
* faint
* underline
* blink

### Combining Colors ###

You can combine multiple colors and styles by defining an array instead of
just a string. For example, this monstrosity:

```puppet
class { '::colorprompt':
  env_name  => 'ATROCIOUS',
  env_color => [ 'underline', 'green', 'bg_red' ],
}
```

## Reference ##

### Classes ###

* `colorprompt`: Creates the script in /etc/profile.d/

### Parameters ###

#### `ensure` ####

*Control if this module's functionality is active.*  
Type: String  
Default: 'present'

#### `path` ####

*Path to the colorprompt script.*  
Type: String  
Default: '/etc/profile.d/colorprompt.sh'

#### `default_usercolor` ####
*Sets a color for all users. Specific user colors can be overridden
by `custom_usercolors`.*  
Type: String or Hash  
Default: undef

#### `custom_usercolors` ####
*Sets the color for specific users.*  
Type: Hash  
Default: { 'root' => 'red' }

#### `host_color` ####
*Which color to use for the host portion of the prompt.*  
Type: String or Array  
Default: undef

#### `env_name` ####
*The string added to the beginning of the prompt, 'DEV', 'PROD', etc.*  
Type: String  
Default: undef

#### `env_color` ####
*Color of the string added to the beginning of the prompt, see 'env_name'.*  
Type: String or Array  
Default: undef

#### `prompt` ####
*Format of the $PS1 variable. Use ${env}, ${userColor} and ${hostColor}.*  
Type: String  
Default:  
`${env}[${userColor}\u\[\e[0m\]@${hostColor}\h\[\e[0m\] \w]\\\\$ ` on RedHat  
`${env}${debian_chroot:+($debian_chroot)}${userColor}\u\[\e[0m\]@${hostColor}\h\[\e[0m\]:\w\\\\$ ` on Debian

#### `modify_skel` ####
*Comments out PS1 variables in /etc/skel/.bashrc on Debian distributions.*  
Type: Boolean  
Default: true on Debian, false on RedHat

#### `modify_root` ####
*Comments out PS1 variables in /root/.bashrc on Debian distributions.*  
Type: Boolean  
Default: true on Debian, false on RedHat

## Authors ##

```plaintext
Copyright 2014-2015 Gjermund Jensvoll <gjerjens@gmail.com>
Copyright 2018 John Marion <jmarion-ext@arista.com>
```

## Limitations ##

Ubuntu and Debian need modification to existing user ~/.bashrc files (comment
out PS1 variables).
