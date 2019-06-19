# Accessibility Audit
Automated accessibility checkers can be used to help identify accessibility issues in digital services. They're good for finding simple and obvious problems, but aren't able to detect many accessibility issues.
Test your code regularly, using both automated and manual testing.

This test suite uses [AXE](https://www.deque.com/axe/), [Google Lighthouse](https://developers.google.com/web/tools/lighthouse/) and [Pa11y](http://pa11y.org/).

## Quick start
```bash
git clone https://github.com/naseberry/accessibility-audit.git
cd accessibility-audit
npm install
```

## Running the audit
To run the audit, add pathname to `pathname.txt`, then run the command below, replace the hostname with your own.
The report for each audit will be written to a named directory with an index file.

```
hostname=https://www.example.com npm test
```

### AXE
```
hostname=https://www.example.com npm run test-axe
```

### Google Lighthouse
```
hostname=https://www.example.com npm run test-lighthouse
```

### Pa11y
```
hostname=https://www.example.com npm run test-pa11y
```

## Testing on a site with authentication
axe-cli is unable to interact with the web page, therefore it is suggested to use axe-webdriverjs instead.

[Google Lighthouse](https://github.com/GoogleChrome/lighthouse/blob/master/docs/readme.md#testing-on-a-site-with-authentication) is unable to interact with the web page, its' documentation suggests running chrome-debug.

[Pa11y actions](https://github.com/pa11y/pa11y#actions) can be used to interact with the page, therefore you would be able to test pages requiring authentication.

## Useful resources
- https://www.gov.uk/service-manual/helping-people-to-use-your-service/testing-for-accessibility#automated-testing