.PHONY: changelog release

SEMTAG = tools/semtag
SCOPE ?= minor
NEXT_TAG := $(shell tools/semtag final -fos $(SCOPE))

release: checkout-release-branch changelog commit-changelog push-release-branch create-push-tag

create-push-tag:
	$(SEMTAG) final -fs $(SCOPE)

push-release-branch:
	git push --set-upstream origin release/$(NEXT_TAG)

commit-changelog:
	git commit CHANGELOG.md -m "Update CHANGELOG"

changelog:
	git-chglog -o CHANGELOG.md --next-tag $(NEXT_TAG)

checkout-release-branch:
	git checkout -b release/$(NEXT_TAG)
