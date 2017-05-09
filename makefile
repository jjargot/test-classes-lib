PROJECT := test-classes.jar

NUMBER_OF_CLASSES := 2000
NUMBER_OF_METHODS_PER_CLASS := 5

all: target/inputObject.xml
.PHONY : clean all 

target/src:
	mkdir -p $@

target/build:
	mkdir -p $@

target/download:
	mkdir -p $@

target/src/com/support/bonitasoft/autogen/TestC.java: target/src src/bin/generateclasses.sh
	cd target/src &&\
		../../src/bin/generateclasses.sh $(NUMBER_OF_CLASSES) $(NUMBER_OF_METHODS_PER_CLASS)

target/xstream-1.4.9/lib/xstream-1.4.9.jar: target/download
		wget -qO target/download/xstream-distribution-1.4.9-bin.zip http://repo1.maven.org/maven2/com/thoughtworks/xstream/xstream-distribution/1.4.9/xstream-distribution-1.4.9-bin.zip &&\
		unzip -d target target/download/xstream-distribution-1.4.9-bin.zip xstream-1.4.9/lib/\* &&\
		touch target/xstream-1.4.9/lib/xstream-1.4.9.jar

target/src/GenerateXML.java: target/src
	cp src/resources/GenerateXML.java $@

target/build/GenerateXML.class: target/build target/xstream-1.4.9/lib/xstream-1.4.9.jar target/src/GenerateXML.java target/src/com/support/bonitasoft/autogen/TestC.java
	javac -d target/build -sourcepath target/src -cp target/xstream-1.4.9/lib/xstream-1.4.9.jar target/src/com/support/bonitasoft/*/*.java target/src/*.java
#	javac -d target/build -sourcepath target/src -cp target/xstream-1.4.9/lib/xstream-1.4.9.jar -Xmx4096m target/src/com/support/bonitasoft/*/*.java target/src/*.java
	
target/test-classes-$(NUMBER_OF_CLASSES)-$(NUMBER_OF_METHODS_PER_CLASS).jar: target/build/GenerateXML.class
	jar cf target/test-classes-$(NUMBER_OF_CLASSES)-$(NUMBER_OF_METHODS_PER_CLASS).jar -C target/build .

target/inputObject.xml: target/test-classes-$(NUMBER_OF_CLASSES)-$(NUMBER_OF_METHODS_PER_CLASS).jar target/xstream-1.4.9/lib/xstream-1.4.9.jar
	cd target &&\
		java -classpath test-classes-$(NUMBER_OF_CLASSES)-$(NUMBER_OF_METHODS_PER_CLASS).jar:xstream-1.4.9/lib/xstream-1.4.9.jar:xstream-1.4.9/lib/xstream/* GenerateXML
#java -Xmx2048m -XX:MaxPermSize=1024m -classpath test-classes-$(NUMBER_OF_CLASSES)-$(NUMBER_OF_METHODS_PER_CLASS).jar:xstream-1.4.9/lib/xstream-1.4.9.jar:xstream-1.4.9/lib/xstream/* GenerateXML

clean:
	-rm -rf target

 
