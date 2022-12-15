#  JVMswitcher

JVMswitcher displays a list of installed Java Virtual Machine (JVM) and lets you select the JVM that shall be used.

## Implementation Idea

- Execute `/usr/libexec/java_home -V` and read the output from stderr.
- Each line shall be checked against the regular expression `/(.*) (.*) "(.*)" - "(.*)" (.*)`
- If it matches, the following values can be extracted:
  - JVM version
  - Architecture
  - Vendor
  - JVM name
  - fully-qualified path to the JVM
- When the user selects a JVM for usage, the following symbolic link to the corresponding JVM directory shall be created: `~/.currentJVM`
- In the `.zprofile` file the following lines need to be added:
  ```bash
  export JAVA_HOME=$HOME/.currentJVM
  export PATH=$JAVA_HOME/bin:$PATH
  ```
