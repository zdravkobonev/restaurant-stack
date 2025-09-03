{{/* Namespace = винаги release namespace */}}
{{- define "org.ns" -}}
{{ .Release.Namespace }}
{{- end -}}

{{/* FE hostname: <ns>-fe.<baseDomain> (освен ако hostFE е зададен изрично) */}}
{{- define "org.ingress.hostFE" -}}
{{- if .Values.ingress.hostFE -}}
{{ .Values.ingress.hostFE }}
{{- else -}}
{{ printf "%s-fe.%s" (include "org.ns" .) (default "local" .Values.ingress.baseDomain) }}
{{- end -}}
{{- end -}}

{{/* BE hostname: <ns>-api.<baseDomain> (освен ако hostBE е зададен изрично) */}}
{{- define "org.ingress.hostBE" -}}
{{- if .Values.ingress.hostBE -}}
{{ .Values.ingress.hostBE }}
{{- else -}}
{{ printf "%s-api.%s" (include "org.ns" .) (default "local" .Values.ingress.baseDomain) }}
{{- end -}}
{{- end -}}

{{/* FE origin: http://<fe-host> */}}
{{- define "org.ingress.originFE" -}}
{{ printf "http://%s" (include "org.ingress.hostFE" .) }}
{{- end -}}

{{/* CORS allowed origins (nil-safe):
     ако backend.cors.allowedOrigins е празен или липсва → ползвай FE origin-а */}}
{{- define "org.cors.allowedOrigins" -}}
{{- $cors := default (dict) .Values.backend.cors -}}
{{- $allowed := default (list) $cors.allowedOrigins -}}
{{- if gt (len $allowed) 0 -}}
{{ join "," $allowed }}
{{- else -}}
{{ include "org.ingress.originFE" . }}
{{- end -}}
{{- end -}}
