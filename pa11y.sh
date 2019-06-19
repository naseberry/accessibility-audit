#! /bin/bash


# Variables to configure our reporting
pa11y_ci=./node_modules/.bin/pa11y

pa11y_directory=pa11y
tmp_directory=tmp

# The report layout
html_start="<html><head><title>Pa11y report</title><link rel='stylesheet' href='main.css'/></head><body><main><section><div class='container'><h1>Pa11y report</h1><ol>"
html_content=""
html_end="</ol></div></section></main></body></html>"

echo "Running Pa11y tests:"

# Create a directory to store our Pa11y builds
echo "Creating artifacts directory: $pa11y_directory/$tmp_directory"
rm -rf $pa11y_directory/*
mkdir -p $pa11y_directory/$tmp_directory

# Run multiple Pa11y audit and threshold for the CI to pass
pa11y_exit_status=0
test_number=0


# Loop each path within pathname.txt
for path in $(cat pathname.txt); do

  echo "Testing: $hostname$path"
  ($pa11y_ci --reporter html $hostname$path > $pa11y_directory/$tmp_directory/report.html)
  pa11y_test_status=$?

  echo "Exited with: $pa11y_test_status"

  html_content+="<li><a href='$test_number/report.html'>${path}</a>"

  if [[ $pa11y_test_status != 0 ]]; then
    pa11y_exit_status=$pa11y_test_status
  fi

  echo "Saving report to $pa11y_directory/$test_number"
  mkdir -p $pa11y_directory/$test_number
  mv $pa11y_directory/$tmp_directory/report.html $pa11y_directory/$test_number/

  html_content+="</li>"

  test_number=$(($test_number + 1))
done

# Clean-up
echo "Cleaning up artifact tmp directory"
rm -r $pa11y_directory/$tmp_directory

# Build report index
echo "Building: $pa11y_directory/index.html"
echo $html_start$html_content$html_end > $pa11y_directory/index.html

# Open in browser
# Remove, will not work in CI
open $pa11y_directory/index.html

# Exit
echo "Exiting pa11y script with: $pa11y_exit_status"
exit $((pa11y_exit_status))