INPUT_EXTENSIONS=.md .html

.SUFFIXES: ${INPUT_EXTENSIONS} .html
.PHONY: clean

POSTS_DIR=${CWD}posts
.OBJDIR=${CWD}output

PERL=/usr/bin/perl
MD=Markdown_1.0.1/Markdown.pl

SRC_FILES!=find ${POSTS_DIR} -type f 2>/dev/null || true

HEADER=_header.html
FOOTER=_footer.html

OUTPUT_FILES=
.for SRC_FILE_NAME in ${SRC_FILES}
OUTPUT_FILES+=${SRC_FILE_NAME:S/${POSTS_DIR}/${.OBJDIR}/:S/.md/.html/}
${SRC_FILE_NAME:S/${POSTS_DIR}/${.OBJDIR}/:S/.md/.html/}: ${SRC_FILE_NAME}
	@echo "Making: $? -> $@"
	@mkdir -p ${@:C/[^\/]*$//}

.	if "${SRC_FILE_NAME:C/.*\.//}" == "md"
	@sed 's|TITLE|$*|' ${HEADER} > $@
	@${PERL} ${MD} < $? >> $@
	@cat ${FOOTER} >> $@
.	elif "${SRC_FILE_NAME:C/.*\.//}" == "html"
	@sed 's|TITLE|$*|' ${HEADER} > $@
	@cat $? >> $@
	@cat ${FOOTER} >> $@
.	else
	@cp $? -> $@
.	endif

.endfor

clean:
	echo ${.OBJDIR}
.	if "${.OBJDIR}" == ""
	@echo "Target .OBJDIR is set to empty. Cowardly failing!"
	@false
.	else
	-echo rm -vr ${.OBJDIR}/* 2>/dev/null
.	endif

.MAIN: ${OUTPUT_FILES}
