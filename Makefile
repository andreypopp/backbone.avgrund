ALL = backbone.avgrund.js backbone.avgrund.css

all: $(ALL)

watch:
	watch -n0.5 $(MAKE) all

backbone.avgrund.js: backbone.avgrund.coffee
	coffee --map -bc $<

backbone.avgrund.css: backbone.avgrund.sass
	sass --compass $< > $@

clean:
	rm -f $(ALL)

publish:
	git push
	git push --tags
	npm publish
