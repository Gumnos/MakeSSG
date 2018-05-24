INPUT_EXTENSIONS=.md .html

.SUFFIXES: ${INPUT_EXTENSIONS} .html

POSTS_DIR=${CWD}posts/
OUTPUT_DIR=${CWD}output/

.PHONY: outputdir

PERL=/usr/bin/perl
MD=Markdown_1.0.1/Markdown.pl

INPUT_FILES=${INPUT_EXTENSIONS:C/\./${POSTS_DIR}\/*./g}

SRC!=ls ${INPUT_FILES} 2>/dev/null || true
OUTPUT=${SRC:.md=.html:C/${POSTS_DIR}/${OUTPUT_DIR}/g}

HEADER=_header.html
FOOTER=_footer.html

.md.html: ${HEADER} ${FOOTER}
	sed 's|TITLE|$*|' ${HEADER} > $*.html
	${PERL} ${MD} < $< >> $*.html
	cat ${FOOTER} >> $*.html

clean:
	rm -vr ${OUTPUT_DIR}/* 2>/dev/null || true

#tkc: ${OUTPUT}
#	echo ${INPUT_FILES}

outputdir: ${OUTPUT_DIR}

${OUTPUT_DIR}:
	@mkdir -p "${OUTPUT_DIR}"

output: outputdir ${OUTPUT}

.MAIN: ${OUTPUT}
