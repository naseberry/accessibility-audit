#! /bin/bash


# Testing on a site with authentication
# https://github.com/GoogleChrome/lighthouse/blob/master/docs/readme.md#testing-on-a-site-with-authentication

# Variables to configure our reporting
lighthouse_ci=./node_modules/.bin/lighthouse-ci

accessibility_pass_rate=100
best_practice_pass_rate=0
performance_pass_rate=0
pwa_pass_rate=0
seo_pass_rate=0

lighthouse_directory=lighthouse
tmp_directory=tmp

# The report layout
html_start="<html><head><title>Lighthouse report</title><link rel='stylesheet' href='main.css'/></head><body><main><section><div class='container'><h1>Lighthouse report</h1><ol>"
html_content=""
html_end="</ol></div></section></main></body></html>"


echo "Running Lighthouse tests:"

# Echo out pass rates for clarity
echo "========================"
echo "|      Pass rates      |"
echo "------------------------"
echo "Performance:         $performance_pass_rate"
echo "Progressive Web App: $pwa_pass_rate"
echo "Acessibility:        $accessibility_pass_rate"
echo "Best Practice:       $best_practice_pass_rate"
echo "SEO:                 $seo_pass_rate"
echo "========================"

# Create a directory to store our lighthouse builds
echo "Creating artifacts directory: $lighthouse_directory/$tmp_directory"
rm -rf $lighthouse_directory/*
mkdir -p $lighthouse_directory/$tmp_directory

# Run multiple Lighthouse audit and threshold for the CI to pass
lighthouse_exit_status=0
lighthouse_test_number=0


# Loop each path within pathname.txt
for path in $(cat pathname.txt); do

  echo "Testing: $hostname$path"
  ($lighthouse_ci $hostname$path --accessibility=$accessibility_pass_rate --best-practice=$best_practice_pass_rate --performance=$performance_pass_rate --pwa=$pwa_pass_rate --seo=$seo_pass_rate --report=$lighthouse_directory/$tmp_directory)
  lighthouse_test_status=$?

  echo "Exited with: $lighthouse_test_status"

  html_content+="<li><a href='$lighthouse_test_number/report.html'>${path}</a>"

  if [[ $lighthouse_test_status != 0 ]]; then
    lighthouse_exit_status=$lighthouse_test_status
    html_content+=" &#x274C;"
  else
    html_content+=" &#x1F389;"
  fi

  echo "Saving report to $lighthouse_directory/$lighthouse_test_number"
  mkdir -p $lighthouse_directory/$lighthouse_test_number
  mv $lighthouse_directory/$tmp_directory/report.html $lighthouse_directory/$lighthouse_test_number/

  html_content+="</li>"

  lighthouse_test_number=$(($lighthouse_test_number + 1))
done

# Clean-up
echo "Cleaning up artifact tmp directory"
rm -r $lighthouse_directory/$tmp_directory

# Build report index
echo "Building: $lighthouse_directory/index.html"
echo $html_start$html_content$html_end > $lighthouse_directory/index.html

# Open in browser
# Remove, will not work in CI
open $lighthouse_directory/index.html

# Exit
echo "Exiting lighthouse script with: $lighthouse_exit_status"
exit $((lighthouse_exit_status))