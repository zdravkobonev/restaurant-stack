{{/* Namespace = винаги release namespace */}}
{{- define "restaurant.ns" -}}
{{ .Release.Namespace }}
{{- end -}}

{{/* Release/restaurant име (взема се от HelmRelease.spec.releaseName) */}}
{{- define "restaurant.name" -}}
{{ .Release.Name }}
{{- end -}}

{{/* Построй пълно име: <release>-<name>  */}}
{{- define "restaurant.fullname" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- printf "%s-%s" (include "restaurant.name" $root) $name -}}
{{- end -}}

{{/* Общи labels с компонент */}}
{{- define "restaurant.labels" -}}
{{- $root := .root -}}
{{- $component := .component -}}
app.kubernetes.io/name: {{ include "restaurant.name" $root }}
app.kubernetes.io/instance: {{ include "restaurant.name" $root }}
app.kubernetes.io/part-of: restaurants
app.kubernetes.io/component: {{ $component }}
{{- end -}}

{{/* Selector labels – използваме само стабилните ключове */}}
{{- define "restaurant.selectorLabels" -}}
{{- $root := .root -}}
{{- $component := .component -}}
app.kubernetes.io/instance: {{ include "restaurant.name" $root }}
app.kubernetes.io/component: {{ $component }}
{{- end -}}

{{/* FE hostname: <release>-fe.<baseDomain> (освен ако hostFE е зададен изрично) */}}
{{- define "restaurant.ingress.hostFE" -}}
{{- if .Values.ingress.hostFE -}}
{{ .Values.ingress.hostFE }}
{{- else -}}
{{ printf "%s-fe.%s" (include "restaurant.name" .) (default "local" .Values.ingress.baseDomain) }}
{{- end -}}
{{- end -}}

{{/* BE hostname: <release>-api.<baseDomain> (освен ако hostBE е зададен изрично) */}}
{{- define "restaurant.ingress.hostBE" -}}
{{- if .Values.ingress.hostBE -}}
{{ .Values.ingress.hostBE }}
{{- else -}}
{{ printf "%s-api.%s" (include "restaurant.name" .) (default "local" .Values.ingress.baseDomain) }}
{{- end -}}
{{- end -}}

{{/* FE origin: http://<fe-host> */}}
{{- define "restaurant.ingress.originFE" -}}
{{ printf "http://%s" (include "restaurant.ingress.hostFE" .) }}
{{- end -}}

{{/* CORS allowed origins (nil-safe):
     ако backend.cors.allowedOrigins е празен или липсва → ползвай FE origin-а */}}
{{- define "restaurant.cors.allowedOrigins" -}}
{{- $cors := default (dict) .Values.backend.cors -}}
{{- $allowed := default (list) $cors.allowedOrigins -}}
{{- if gt (len $allowed) 0 -}}
{{ join "," $allowed }}
{{- else -}}
{{ include "restaurant.ingress.originFE" . }}
{{- end -}}
{{- end -}}
