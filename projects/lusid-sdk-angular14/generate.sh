#!/bin/bash -e

lusidApiUrl=https://www.lusid.com/api/swagger/v0/swagger.json
projectName=lusid-sdk-angular14

pushd ../..

echo "getting latest LUSID API openapi spec from $lusidApiUrl"
curl --output lusid.json -X GET $lusidApiUrl 

echo
echo "removing old files"
echo "  projects/$projectName/src/lib/.generated" && rm -rf projects/$projectName/src/lib/.generated
echo "  dist" && rm -rf dist
echo "  node_modules" && rm -rf node_modules

echo
echo "Generating and building the code (using docker)"
docker compose -f docker-compose.yml up --build
docker compose -f docker-compose.yml down

echo
echo "packaging and pushing the generated code"
pushd dist/$projectName
npm pack
npm publish finbourne-$projectName-*.tgz --access public
popd

popd
