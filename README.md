Shell-ShellNS-Log
================================

> [Aeon Digital](http://www.aeondigital.com.br)  
> rianna@aeondigital.com.br

&nbsp;

``ShellNS Log`` Provides a simple way to keep a log of functions and 
processes.  


&nbsp;
&nbsp;

________________________________________________________________________________

## Main

After downloading the repo project, go to its root directory and use one of the 
commands below

``` shell
# Loads the project in the context of the Shell.
# This will download all dependencies if necessary. 
. main.sh "run"



# Installs dependencies (this does not activate them).
. main.sh install

# Update dependencies
. main.sh update

# Removes dependencies
. main.sh uninstall




# Runs unit tests, if they exist.
. main.sh utest

# Runs the unit tests and stops them on the first failure that occurs.
. main.sh utest 1



# Export a new 'package.sh' file for use by the project in standalone mode
. main.sh export


# Exports a new 'package.sh'
# Export the manual files.
# Export the 'ns.sh' file.
. main.sh extract-all
```

&nbsp;
&nbsp;


________________________________________________________________________________

## Standalone

To run the project in standalone mode without having to download the repository 
follow the guidelines below:  

``` shell
# Download with CURL
curl -o "shellns_log_standalone.sh" \
"https://raw.githubusercontent.com/AeonDigital/Shell-ShellNS-Log/refs/heads/main/standalone/package.sh"

# Give execution permissions
chmod +x "shellns_log_standalone.sh"

# Load
. "shellns_log_standalone.sh"
```


&nbsp;
&nbsp;

________________________________________________________________________________

## How to use

### Write and Read logs

**Examples:**

``` shell
# Write
shellNS_log_write "My first message"
shellNS_log_write "My seccond message"
shellNS_log_write "And another message!"


# Read last one
shellNS_log_read
And another message!


# Read last two
shellNS_log_read 2
And another message!
My seccond message


# Read all history
shellNS_log_read 0
And another message!
My seccond message
My first message


# Read and show the index of message
shellNS_log_read 2 1
[ 2 ] And another message!
[ 1 ] My seccond message


# Read in ascendent order
shellNS_log_read 2 1 asc
[ 1 ] My first message
[ 0 ] My seccond message
[ 2 ] And another message!
```

&nbsp;
&nbsp;

________________________________________________________________________________

## Licence

This project uses the [MIT License](LICENCE.md).