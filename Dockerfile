FROM alpine:latest
RUN apk update && apk add curl unzip
WORKDIR /sudachi-dictionary

RUN curl -sSL -o sudachi-dictionary-core.zip https://github.com/WorksApplications/SudachiDict/releases/download/v20260116/sudachi-dictionary-20260116-core.zip
RUN unzip sudachi-dictionary-core.zip

RUN curl -sSL -o sudachi-dictionary.zip https://github.com/WorksApplications/SudachiDict/releases/download/v20260116/sudachi-dictionary-20260116-full.zip
RUN unzip -o sudachi-dictionary.zip

FROM opensearchproject/opensearch:3.5.0
RUN /usr/share/opensearch/bin/opensearch-plugin install --batch \
    https://github.com/WorksApplications/elasticsearch-sudachi/releases/download/v3.4.0/opensearch-2.19.4-analysis-sudachi-3.4.0.zip
COPY --from=0 /sudachi-dictionary/sudachi-dictionary-20260116 config/sudachi/
RUN mkdir -p /usr/share/opensearch/data && chown 1000:1000 /usr/share/opensearch/data

