{{/* Връща namespace-а за инстанцията */}}
{{- define "org.ns" -}}
{{- if .Values.orgName -}}
{{ .Values.orgName }}
{{- else -}}
{{ .Release.Namespace }}
{{- end -}}
{{- end -}}

{{/* FE hostname: <org>-fe.<baseDomain> (освен ако hostFE е зададен изрично) */}}
{{- define "org.ingress.hostFE" -}}
{{- if .Values.ingress.hostFE -}}
{{ .Values.ingress.hostFE }}
{{- else -}}
{{ printf "%s-fe.%s" (include "org.ns" .) (default "local" .Values.ingress.baseDomain) }}
{{- end -}}
{{- end -}}

{{/* BE hostname: <org>-api.<baseDomain> (освен ако hostBE е зададен изрично) */}}
{{- define "org.ingress.hostBE" -}}
{{- if .Values.ingress.hostBE -}}
{{ .Values.ingress.hostBE }}
{{- else -}}
{{ printf "%s-api.%s" (include "org.ns" .) (default "local" .Values.ingress.baseDomain) }}
{{- end -}}
{{- end -}}
