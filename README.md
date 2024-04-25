# Parent repository for the Leolani workshop

This repository contains a demo application for the Leolani workshop.

## Check-out

To check out all code needed for the Leolani App, clone this repository including all submodules:

        git clone --recurse-submodules -j8 https://github.com/leolani/workshop-parent.git

Update to the latest branch heads of the submodules:

        git submodule update --remote

To pull the latest changes, you can run:

        git pull --recurse-submodules

To push some submodule changes, go to the submodule folder and push like:

        git push origin HEAD:main

## Installation requirements

For installation requirements checkout the description in this [README](https://github.com/leolani/cltl-combot/tree/4516bea55175f646643a88e74aa1a242f5a306c0?tab=readme-ov-file#prerequisites).

## Run the application

Checkout the repository as described in [Check-out](#check-out). Then go to the repository root, build the project,
activate the virtual environment for the Python application and run it. Altogether:

        git clone --recurse-submodules -j8 https://github.com/leolani/leolani-mmai-parent.git
        cd workshop-parent
        make build
        cd workshop-app
        source venv/bin/activate
        cd py-app
        python app.py

You can then go to the chat interface [here](http://0.0.0.0:8000/chatui/static/chat.html) to type and see what the
system hears. You can also see what the systems sees [here](http://0.0.0.0:8000/monitoring/static/monitoring.html).

## Create your own application

Starting from this repository you can setup your own application:

* Choose a project name, e.g. `myproject`
* Create two empty repositories on GitHub with names
  * `myproject-parent`
  * `myproject-app`
* Follow the steps in the `./setup_parent.sh` script:
  * initialize `myproject-parent` with basic files, like README, VERSION and the makefile from this repository
  * create `cltl-requirements` in the parent
  * add the used components as git submodules to the parent
  * create an application from cltl-template
  * we set up the application from this repository
  * Adjust the `workshop` name of your project in
    * project-dependencies of myproject-parent/makefile
    * project-dependencies of myproject-parent/myproject-app/makefile
    * name in parent/project-app/setup.py

This will provide you with an identical setup to this application, though using your project name.

To add your own modules, for simplicity place them in `myproject-parent/src` in the `workshop` and `workshop_parent`
namespaces. Like this you do not need to add additional git submodules. If you want to try that, you can move the code
at any point.

To add them to the application follow the patterns used for the Eliza component (cltl-eliza).

NOTES:

- The `make build` may take 5 - 10 min
- If you use a knowledge Graph, remember to launch GraphDB and have a repository called 'sandbox'
- Remember to launch Docker before running
- Remember to use the virtual environment (created by the `make build`command) located at `cltl-leolani-app/venv`
