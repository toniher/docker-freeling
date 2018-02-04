
MPATH=/usr/local/opt/gnu-tar/libexec/gnubin:$(PATH)
IMAGE=toniher/freeling4
BUILDTAG=v0
PUBLITAG=pub
DOCKERCFG=dependencies.docker freeling.docker locale.docker
FREELINGTAG=4.0

Dockerfile: Dockerfile.m4 $(DOCKERCFG) python.docker pyfreeling.docker
	svn export --force -q https://github.com/TALP-UPC/FreeLing.git/tags/$(FREELINGTAG)/APIs/python APIs/python
	svn export --force -q https://github.com/TALP-UPC/FreeLing.git/tags/$(FREELINGTAG)/APIs/common APIs/common
	m4 --define=py-dv --define=fl Dockerfile.m4 > Dockerfile

build: Dockerfile
	docker build -t $(IMAGE):$(BUILDTAG) -f Dockerfile .
	touch build


clean:
	rm -f Dockerfile build squash


## because docker-squash must run as root it asks its password
squash: build
	$(eval IMAGEID = $(shell docker images -q $(IMAGE):$(BUILDTAG))) \
	docker save $(IMAGEID) | \
	PATH=$(MPATH) sudo docker-squash -t $(IMAGE):$(PUBLITAG) |  \
	docker load
	touch squash

publish: squash
	docker push $(IMAGE):$(PUBLITAG)
