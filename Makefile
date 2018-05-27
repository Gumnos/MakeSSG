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
	@echo "Making: $? -> $@ (${SRC_FILE_NAME:C/.*\.//})"

	sed 's|TITLE|$*|' ${HEADER} > $@
.	if "${SRC_FILE_NAME:C/.*\.//}" == "md"
	${PERL} ${MD} < $? >> $@
.	else
	cat $? >> $@
.	endif
	cat ${FOOTER} >> $@

.endfor

clean:
	rm -v ${.OBJDIR}/* 2>/dev/null

.MAIN: ${OUTPUT_FILES}
