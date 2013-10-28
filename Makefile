
all: bundle
bundle:
	tar --exclude="Makefile" --exclude='.git' --exclude='.DS_Store' --exclude='Gemfile' --exclude='Gemfile.lock' --exclude='gen.rb' --exclude='download.rb' --exclude='generated.sql' -cvzf nginx.tgz ../nginx.docset
