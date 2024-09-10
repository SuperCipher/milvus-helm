{{- define "milvus.config" -}}
# Copyright (C) 2019-2021 Zilliz. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under the License.

{{- $namespace := .Release.Namespace }}

metastore:
  type: etcd

{{- if and (.Values.externalS3.enabled) (eq .Values.externalS3.cloudProvider "azure") }}
common:
  storageType: remote
{{- end }}

minio:
{{- if .Values.externalS3.enabled }}
  address: {{ .Values.externalS3.host }}
  port: {{ .Values.externalS3.port }}
  accessKeyID: {{ .Values.externalS3.accessKey }}
  secretAccessKey: {{ .Values.externalS3.secretKey }}
  useSSL: {{ .Values.externalS3.useSSL }}
  bucketName: {{ .Values.externalS3.bucketName }}
  rootPath: {{ .Values.externalS3.rootPath }}
  useIAM: {{ .Values.externalS3.useIAM }}
  cloudProvider: {{ .Values.externalS3.cloudProvider }}
  iamEndpoint: {{ .Values.externalS3.iamEndpoint }}
  region: {{ .Values.externalS3.region }}
  useVirtualHost: {{ .Values.externalS3.useVirtualHost }}
{{- end }}

{{- if not .Values.cluster.enabled }}
{{- if or (eq .Values.standalone.messageQueue "rocksmq") (eq .Values.standalone.messageQueue "natsmq") }}

mq:
  type: {{ .Values.standalone.messageQueue }}

messageQueue: {{ .Values.standalone.messageQueue }}
{{- end }}
{{- end }}

queryNode:
  port: 21123
{{- if .Values.cluster.enabled }}
  enableDisk: {{ .Values.queryNode.disk.enabled }} # Enable querynode load disk index, and search on disk index
{{- else }}
  enableDisk: {{ .Values.standalone.disk.enabled }} # Enable querynode load disk index, and search on disk index
{{- end }}

log:
  level: {{ .Values.log.level }}
  file:
{{- if .Values.log.persistence.enabled }}
    rootPath: "{{ .Values.log.persistence.mountPath }}"
{{- else }}
    rootPath: ""
{{- end }}
    maxSize: {{ .Values.log.file.maxSize }}
    maxAge: {{ .Values.log.file.maxAge }}
    maxBackups: {{ .Values.log.file.maxBackups }}
  format: {{ .Values.log.format }}

{{- end }}
