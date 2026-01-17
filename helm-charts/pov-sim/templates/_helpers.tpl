{{/*
Expand the name of the chart.
*/}}
{{- define "pov-sim.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "pov-sim.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pov-sim.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pov-sim.labels" -}}
helm.sh/chart: {{ include "pov-sim.chart" . }}
{{ include "pov-sim.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pov-sim.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pov-sim.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "pov-sim.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pov-sim.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Airlines service labels
*/}}
{{- define "pov-sim.airlines.labels" -}}
{{ include "pov-sim.labels" . }}
app.kubernetes.io/component: airlines
{{- end }}

{{/*
Airlines selector labels
*/}}
{{- define "pov-sim.airlines.selectorLabels" -}}
{{ include "pov-sim.selectorLabels" . }}
app.kubernetes.io/component: airlines
{{- end }}

{{/*
Flights service labels
*/}}
{{- define "pov-sim.flights.labels" -}}
{{ include "pov-sim.labels" . }}
app.kubernetes.io/component: flights
{{- end }}

{{/*
Flights selector labels
*/}}
{{- define "pov-sim.flights.selectorLabels" -}}
{{ include "pov-sim.selectorLabels" . }}
app.kubernetes.io/component: flights
{{- end }}

{{/*
Frontend service labels
*/}}
{{- define "pov-sim.frontend.labels" -}}
{{ include "pov-sim.labels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Frontend selector labels
*/}}
{{- define "pov-sim.frontend.selectorLabels" -}}
{{ include "pov-sim.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end }}
