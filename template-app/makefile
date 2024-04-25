SHELL = /bin/bash

project_dependencies ?= $(addprefix $(project_root)/, \
		emissor \
		cltl-combot \
		cltl-requirements \
		cltl-backend \
		cltl-context \
		cltl-object-recognition \
		cltl-vad \
		cltl-asr \
		cltl-emissor-data \
		cltl-eliza \
		cltl-chat-ui \
		template-app)

git_remote ?= https://github.com/leolani

include util/make/makefile.base.mk
include util/make/makefile.py.base.mk
include util/make/makefile.git.mk
