FROM maven:3.8-jdk-11

RUN mkdir -p /usr/swaggerjar/
WORKDIR /usr/swaggerjar/

RUN apt-get update && \
    apt-get -y install curl gnupg && \
    curl -sL https://deb.nodesource.com/setup_14.x  | bash - && \
    apt-get -y install nodejs && \
    apt-get -y install jq

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	--no-install-recommends \
	&& apt-get update && apt-get install -y \
	chromium \
	chromium-sandbox \
	fontconfig \
	fonts-ipafont-gothic \
	fonts-wqy-zenhei \
	fonts-thai-tlwg \
	fonts-kacst \
	fonts-symbola \
	fonts-noto \
	fonts-freefont-ttf \
	--no-install-recommends \
	&& apt-get purge --auto-remove -y curl gnupg \
	&& rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN /usr/bin/chromium

# Don't use 5.3.1 or 5.4.0 as they generate invalid httpClient calls for DELETE operations!
RUN wget https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/5.3.0/openapi-generator-cli-5.3.0.jar -O  /usr/swaggerjar/openapi-generator-cli.jar

ADD generate.sh .

ENTRYPOINT [ "/bin/bash", "generate.sh" ]
