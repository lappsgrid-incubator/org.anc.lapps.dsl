VERSION=$(shell cat VERSION)
JAR=target/lsd-$(VERSION).jar
# Where the jar file and startup script will be copied.
BIN=$(HOME)/bin

help:
	@echo
	@echo "Available goals are:"
	@echo
	@echo "    clean : Clean removes all artifacts from previous builds"
	@echo "      jar : Creates the lapps.jar file."
	@echo "  install : Copies the jar to the user's bin directory."
	@echo "  release : Zips executables and uploads to the ANC web server."
	@echo "      all : Does all of the above."
	@echo "     help : Displays this help message."
	@echo
	
jar:
	export MAVEN_OPTS="-Xmx512m -Xms128m -Xss2m" && mvn package
	./rename.sh
	
clean:
	mvn clean
	
install:
	cp $(JAR) $(BIN)
	cat src/test/resources/lsd | sed 's/__VERSION__/$(VERSION)/' > $(BIN)/lsd
	
debug:
	@echo "Current version is $(VERSION)"
	
release:
	#mvn clean package
	if [ ! -f $(JAR) ] ; then mvn clean package ; fi
	cat src/test/resources/lsd | sed 's/__VERSION__/$(VERSION)/' > target/lsd
	cd target ; zip lsd-$(VERSION).zip lsd-$(VERSION).jar lsd ; cp lsd-$(VERSION).zip lsd-latest.zip
	cd target ; tar -czf lsd-$(VERSION).tgz lsd-$(VERSION).jar lsd ; cp lsd-$(VERSION).tgz lsd-latest.tgz
	scp -P 22022 target/lsd-$(VERSION).zip suderman@anc.org:/home/www/anc/downloads
	scp -P 22022 target/lsd-$(VERSION).tgz suderman@anc.org:/home/www/anc/downloads
	scp -P 22022 target/lsd-latest.zip suderman@anc.org:/home/www/anc/downloads
	scp -P 22022 target/lsd-latest.tgz suderman@anc.org:/home/www/anc/downloads
	#scp -P 22022 target/lsd-latest.tgz suderman@anc.org:/home/www/anc/downloads/docker
	scp -i $(HOME)/.ssh/lappsgrid-shared-key.pem target/lsd-latest.tgz root@downloads.lappsgrid.org:/var/lib/downloads
	echo "Release complete."

all: clean jar install release