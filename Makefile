# Symlink the executable that imports the network_manager_dispatcher_app that is installed for root via Pip
all: install-prod-build

# Run all the unit tests.
test:
	@python3 -m unittest discover $(PWD)/tests '*_test.py'

clean:
	@rm -r dist/* src

# Upgrade pip and build python modules, perform a build then upload the distribution to the appropriate pypi repository.

# Create a distribution, upload to the index, wait for logical time ~10 seconds, attempt pip install of said package.
deploy-prod-build:
	@./bump-cat-semver.py prod-semver.txt
	@rm -rf dist/*
	@python3 -m pip install --upgrade pip
	@python3 -m pip install --upgrade build
	@python3 -m build
	@python3 -m pip install --upgrade twine
	@python3 -m twine upload --repository pypi dist/*
	@echo "Waiting 10 seconds for the package index to refresh."
	@sleep 10
	@git add . && git commit -am "Bumping package version to $$(cat prod-semver.txt), for both prod-semver.txt and setup.cfg" && git push origin main
	@echo "Deploy to pypi was successful! 🚀"

# Create a distribution, upload to the test index, wait..pip install. NOTE: calling syntax is `BUILD=[prod|test] make deploy-build`
deploy-test-build:
	@./bump-cat-semver.py test-semver.txt
	@rm -rf dist/*
	@python3 -m pip install --upgrade pip
	@python3 -m pip install --upgrade build
	@python3 -m build
	@python3 -m pip install --upgrade twine
	@python3 -m twine upload --repository testpypi dist/*
	@echo "Waiting 10 seconds for the package index to refresh."
	@sleep 10
# undo the change to the setup.cfg
	@git checkout setup.cfg
	@git add .
	@git commit -am "Update test-semver.txt to published version $$(cat test-semver.txt)."
	@echo "You need to push the test-semver.txt change to the correct branch. dev?? or main?? depending."
	@echo "Deploy to testpypi was successful! 🚀"

# Install the latest test build for the root user without building or distrubuting.
install-test-build:
	@sudo python3 -m pip install --index-url https://test.pypi.org/simple/ --no-deps $$(basename $$PWD)==$$(cat test-semver.txt)

# Install the latest prod build for the root user without building or distrubuting.
install-prod-build:
	@sudo python3 -m pip install $$(basename $$PWD)==$$(cat prod-semver.txt)

