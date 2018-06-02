.PHONY: clean dirs deploy

POSTS_DIR=${CWD}posts
.OBJDIR=${CWD}output
DEPLOY_DEST=

RSYNC!=which rsync
RSYNC_FLAGS=
PERL!=which perl
MD=Markdown_1.0.1/Markdown.pl

SRC_FILES!=find ${POSTS_DIR} -type f 2>/dev/null || true

HEADER=_header.html
FOOTER=_footer.html

OUTPUT_FILES=
.for SRC_FILE_NAME in ${SRC_FILES}
OUTPUT_FILES+=${SRC_FILE_NAME:S/${POSTS_DIR}/${.OBJDIR}/:S/.md/.html/}
${SRC_FILE_NAME:S/${POSTS_DIR}/${.OBJDIR}/:S/.md/.html/}: ${SRC_FILE_NAME} ${HEADER} ${FOOTER}
	@echo "Making: ${SRC_FILE_NAME} -> $@"
	@mkdir -p ${@:C/[^\/]*$//}

.	if "${SRC_FILE_NAME:C/.*\.//}" == "md"
	@sed 's|TITLE|$*|' ${HEADER} > $@
	@${PERL} ${MD} < ${SRC_FILE_NAME} >> $@
	@cat ${FOOTER} >> $@

.	elif "${SRC_FILE_NAME:C/.*\.//}" == "html"
	@sed 's|TITLE|$*|' ${HEADER} > $@
	@cat ${SRC_FILE_NAME} >> $@
	@cat ${FOOTER} >> $@

.	else
	@cp ${SRC_FILE_NAME} -> $@
.	endif

.endfor

dirs:
	@mkdir -p ${POSTS_DIR} ${.OBJDIR}
	@echo "Hello world" > ${POSTS_DIR}/hello.md

clean:
.	if "${.OBJDIR}" == ""
	@echo "Target .OBJDIR is set to empty. Cowardly failing!"
	@false
.	else
	-rm -vr ${.OBJDIR}/* 2>/dev/null
.	endif

deploy:
.	if "${DEPLOY_DEST}" == ""
	@echo "Must specify DEPLOY_DEST=rsync_path"; false
.	elif "${RSYNC}" == ""
	@echo "Unable to find rsync"; false
.	else
	@echo "Deploying to ${DEPLOY_DEST}"
	@rsync -avr ${RSYNC_FLAGS} ${.OBJDIR}/ ${DEPLOY_DEST}/
.	endif

.MAIN: ${OUTPUT_FILES}
