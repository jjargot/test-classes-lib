# test-classes-lib
Generate a lib containing any specified number of classes with any specified number of methods

## Download
    # git clone https://github.com/jjargot/test-classes-lib

## Edit makefile to set the number of classes to generate and the number of methods per class
    # vi makefile
    NUMBER_OF_CLASSES := 2000
    NUMBER_OF_METHODS_PER_CLASS := 5

## Build
    # make all

### target/test-classes-2000-5.jar 
It contains all the classes generated, ready to be used

### target/inputObject.xml
An XML file containing serialized objects: one instance of each classes

### target/src/GenerateXML.java
An example of use of the classes and it has been used to generate the XML file

