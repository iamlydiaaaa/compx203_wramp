#
# Default new users .profile
#
# 21/05/2001 - Baz
#              University of Waikato
#
# ------------------------------------------------------------------------

#
# "/usr/local/etc/profile" acts on the following toggles.  Uncomment to enable.
#
# If you dont know wha these flags mean then you probably dont need them.
#
#export JAVA1_2=y        # Uncomment to use Sun's Java Developers' Kit version 1.2
#export JAVA1_3=y        # Uncomment to use Sun's Java Developers' Kit version 1.3
#export JAVA1_4=y        # Uncomment to use Sun's Java Developers' Kit version 1.4
#export DOTTY=y        # Uncomment to set up paths for DOTTY
#export AC3D=y  	# Uncomment to set up paths to AC3D
#export CS314A=y	# Uncomment to set up paths for cs-314a
#export CS333A=y	# Uncomment to set up paths for cs-333a
#export CS304A=y	# Uncomment to set up paths for cs-304a
#export CS414A=y	# Uncomment to set up paths for cs-414a
#export CS424=y		# Uncomment to set up paths for cs-424b

# Amulet vars for 201
#export AMULET=y

# MIPS vars for 201
#export CS201A=y

test -x /usr/local/etc/profile && . /usr/local/etc/profile

# If a user has their own manual and binary directories, for example:
#
#MANPATH="$HOME/man:$MANPATH"
#PATH="$HOME/bin:$PATH"
 
# Uncomment to put your working directory in your path (last !)
# PATH="${PATH}:"

# Now run the .bashrc file.  .bashrc should only contain aliases and functions,
# not environment variable settings.
. ~/.bashrc

