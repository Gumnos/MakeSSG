INPUT_EXTENSIONS=.md .html

.SUFFIXES: ${INPUT_EXTENSIONS} .html
.PHONY: clean

POSTS_DIR=${CWD}posts
.OBJDIR=${CWD}output

PERL=/usr/bin/perl
MD=Markdown_1.0.1/Markdown.pl

INPUT_FILES!=find ${POSTS_DIR} -type f 2>/dev/null || true

HEADER=_header.html
FOOTER=_footer.html

OUTPUT_FILES=
.for src_name in ${INPUT_FILES}
OUTPUT_FILES+=${src_name:S/${POSTS_DIR}/${.OBJDIR}/:S/.md/.html/}
${src_name:S/${POSTS_DIR}/${.OBJDIR}/:S/.md/.html/}: ${src_name}
	@echo "Making: $? -> $@ (${src_name:C/.*\.//})"

	sed 's|TITLE|$*|' ${HEADER} > $@
.	if "${src_name:C/.*\.//}" == "md"
	${PERL} ${MD} < $? >> $@
.	else
	cat $? >> $@
.	endif
	cat ${FOOTER} >> $@

.endfor

clean:
	rm -v ${.OBJDIR}/* 2>/dev/null

.MAIN: ${OUTPUT_FILES}
