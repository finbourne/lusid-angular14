# LUSID API Client for Angular 14

This library was generated with [Angular CLI](https://github.com/angular/angular-cli) version 14.2.4.

You can use the standard Angular CLI (ng) commands to enhance this project.

## Overview

This is used to generate the **_lusid-sdk-angular14_** npm package.

This uses **Open API Tools** [openapi-generator-cli](https://github.com/OpenAPITools/openapi-generator) to auto-generate files from the specified LUSID OpenApi specification, available from
[here](https://www.lusid.com/api/swagger/index.html).

To generate the files and build the SDK run the following command after get the latest LUSID API specification from [here](https://www.lusid.com/api/swagger/v0/swagger.json)) and updating the `lusid.json` file

- Get the latest LUSID API specification

```
curl --output lusid.json -X GET https://www.lusid.com/api/swagger/v0/swagger.json
```

- Generate the files and build the project

```
docker compose -f docker-compose.yml up
```

- the built code will be in `dist/lusid-sdk-angular14`
- the generated files will be in `projects\lusid-sdk-angular14\src\lib\.generated`
  - these files are not checked in to git.
- this can take a couple of minutes!
- if you get an error like generate.sh: line 2: $'\r': command not found you need to
  - make sure your generate.sh file is in unix format: unix2dos generate.sh
  - force a rebuild of the container `docker compose -f docker-compose.yml up --build`

## Notes

1. FINBOURNE has a process that automatically builds and deploys this each time the LUSID API changes
   - the resultant npm package will be available at https://www.npmjs.com/package/@finbourne/lusid-sdk-angular14
   - if you want to publish manually then
     - go to `dist/lusid-sdk-angular14`
     - `npm publish . --access public`
1. LUSID API "dates" are now mapped to TypeScript/JavaScript `string` rather than `Date`.
   - This is so that the value can be round-tripped correctly.
   - The issue with using a JavaScript `Date` is that this only has millisecond accuracy, so you can loose information by converting a valid value returned from LUSID into a `Date`. e.g. If you receive **2022-02-20T12:13:14.1234567+00:00** and convert this to a `Date` when you send this back to LUSID you would get **2022-02-20T12:13:14.123Z** \* which isn't the same as the value received.
   - This is for all properties in the [LUSID API specification](https://www.lusid.com/api/swagger/v0/swagger.json) that have `"type": "string". "format": "date-time"`

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI Overview and Command Reference](https://angular.io/cli) page.
