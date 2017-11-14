#!/usr/bin/env bash

# Set this to the name of the Xcode target for the project
NAME=Scribe

################################################################################
# Define the Xcode environment needed if running outside of Xcode

if [ -z "${PROJECT_DIR}" ]
then
  SCRIPT_DIR=$( /usr/bin/dirname "${0}" )
  PROJECT_DIR="${SCRIPT_DIR}/.."
fi

if [ -z "${TARGET_NAME}" ]
then
  TARGET_NAME="${NAME}"
fi
  
################################################################################
# Find a Markdown parser or abort

MARKDOWN=
[ -z "${MARKDOWN}" ] && MARKDOWN=$( /usr/bin/which cmark )
[ -z "${MARKDOWN}" ] && MARKDOWN=$( /usr/bin/which markdown )
if [ ! -x "${MARKDOWN}" ]
then
  echo 'No Markdown parser was found.'                   >&2 
  echo 'Either `cmark` or `markdown` must be installed.' >&2
  exit 1
fi

################################################################################
# Find the CocoaPods acknowledgements Markdown file or abort

INPUT="${PROJECT_DIR}/Pods/Target Support Files/Pods-${TARGET_NAME}/Pods-${TARGET_NAME}-acknowledgements.markdown"
if [ ! -f "${INPUT}" ]
then
  echo 'No acknowledgements file found to parse.' >&2 
  echo "Expected: ${INPUT}"                       >&2
  exit 2
fi

################################################################################
# Verify the output directory exists

OUTPUT_DIR="${PROJECT_DIR}/${TARGET_NAME}/Supporting Files"
if [ ! -d "${OUTPUT_DIR}" ]
then
  echo 'Output directory does not exist.' >&2 
  echo "Expected: ${OUTPUT_DIR}"          >&2
  exit 3
fi

OUTPUT="${OUTPUT_DIR}/Acknowledgements.html"

################################################################################
# Generate the acknowledgements.html file

# Create an empty file, removing any content that was previously there
echo -n '' > "${OUTPUT}"

# Add a header with minimal CSS to make it look decent
cat >> "${OUTPUT}" <<HEADER
  <!doctype html>
  <html class="no-js" lang="">
    <head>
      <meta charset="utf-8">
      <title>Acknowledgements</title>
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

      <style type="text/css" media="screen">
        body { font-family: font-family: system, -apple-system, BlinkMacSystemFont,
          "Helvetica Neue", san-serif; }
        h1 { font-family: -apple-system-headline1, "Helvetica Neue", sans-serif; }
        h2 { font-family: -apple-system-headline2, "Helvetica Neue", sans-serif; }
        h3 { font-family: -apple-system-subheadline1, "Helvetica Neue", sans-serif; }
        h4 { font-family: -apple-system-subheadline2, "Helvetica Neue", sans-serif; }
        p, ul, ol, li, dl, dt, dd { font-family: -apple-system-body, "Helvetica Neue", sans-serif; }
        code, pre { font-family: Menlo, Consolas, Monaco, monospace }
      </style>
    </head>
    <body>
HEADER

# Add the acknowledgements Markdown content
"${MARKDOWN}" "${INPUT}" >> "${OUTPUT}"

# Add a footer
cat >> "${OUTPUT}" <<FOOTER 
    </body>
  </html>
FOOTER
