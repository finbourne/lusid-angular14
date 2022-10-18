#!/bin/bash -e

if [[ ${#1} -eq 0 ]]; then
    echo
    echo "[ERROR] swagger file not specified"
    exit 1
fi

ngVersion=14
gen_root=/usr/src
project_name=lusid-sdk-angular$ngVersion
project_folder=$gen_root/projects/$project_name

sdk_output_folder=$project_folder/src/lib/.generated
swagger_file=$gen_root/$1


echo "gen_root $gen_root"
echo "swagger file $swagger_file"
echo "sdk output folder: $sdk_output_folder"

# remove all previously generated files
shopt -s extglob
echo "removing previous sdk: folder=$sdk_output_folder"
rm -rf $sdk_output_folder
shopt -u extglob
mkdir $sdk_output_folder

echo "node version: $(node --version)"
echo "npm version: $(npm --version)"
echo "openapi-generator-cli version: $(java -jar /usr/swaggerjar/openapi-generator-cli.jar version)"

echo "generating the LUSID API sdk (angular version '$ngVersion'): mapping Object=>any, DateTime=>string"
java -jar /usr/swaggerjar/openapi-generator-cli.jar generate \
    -i $swagger_file \
    -g typescript-angular \
    -o $sdk_output_folder \
    -c $gen_root/config.json \
    --additional-properties ngVersion=$ngVersion \
    --additional-properties npmName=@finbourne/$project_name \
    --type-mappings=Object=any \
    --type-mappings=object=any \
    --type-mappings=DateTime=string

cd $gen_root

sdk_version=$(cat $swagger_file | jq -r '.info.version')

echo "updating version in package.json to '$sdk_version'"
package_json=$gen_root/projects/$project_name/package.json
cat $package_json | jq -r --arg SDK_VERSION "$sdk_version" '.version |= $SDK_VERSION' > temp && mv temp $package_json

echo "installing packages (using 'npm ci') : folder $(pwd)"
npm ci

echo "stop ng from prompting to use analytics (ng analytics off)"
npm run ng -- analytics off

echo "ng version"
npm run ng -- version

echo "running ng build ('ng build $project_name')"
npm run build -- $project_name
