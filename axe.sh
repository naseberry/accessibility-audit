#! /bin/bash


# Variables to configure our reporting
axe_ci=./node_modules/.bin/axe

axe_directory=axe
tmp_directory=tmp

# The report layout
html_start="<html><head><title>AXE report</title><link rel='stylesheet' href='main.css'/></head><body><main><section><div class='container'><h1>AXE report</h1><ol>"
html_content=""
html_end="</ol></div></section></main></body></html>"

echo "Running AXE tests:"

# Create a directory to store our AXE builds
echo "Creating artifacts directory: $axe_directory/$tmp_directory"
rm -rf $axe_directory/*
mkdir -p $axe_directory/$tmp_directory

# Run multiple AXE audit and threshold for the CI to pass
axe_exit_status=0
test_number=0


# Loop each path within pathname.txt
for path in $(cat pathname.txt); do

  echo "Testing: $hostname$path"
  ($axe_ci $hostname$path --save $axe_directory/$tmp_directory/report.json --exit)
  axe_test_status=$?

  echo "Exited with: $axe_test_status"

  html_content+="<li><a href='$test_number/report.json'>${path}</a>"

  if [[ $axe_test_status != 0 ]]; then
    axe_exit_status=$axe_test_status
  fi

  echo "Saving report to $axe_directory/$test_number"
  mkdir -p $axe_directory/$test_number
  mv $axe_directory/$tmp_directory/report.json $axe_directory/$test_number/

  html_content+="</li>"

  test_number=$(($test_number + 1))
done

# Clean-up
echo "Cleaning up artifact tmp directory"
rm -r $axe_directory/$tmp_directory

# Build report index
echo "Building: $axe_directory/index.html"
echo $html_start$html_content$html_end > $axe_directory/index.html

# Open in browser
# Remove, will not work in CI
open $axe_directory/index.html

# Exit
echo "Exiting axe script with: $axe_exit_status"
exit $((axe_exit_status))